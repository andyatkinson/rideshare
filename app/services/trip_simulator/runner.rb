require 'socket'

class TripSimulator
  # A detached Rails task, not a thread in the reloading web process.
  class Runner
    class AlreadyRunning < StandardError; end
    class ResetFailed < StandardError; end
    LOCK_PATH = Rails.root.join("tmp/simulator-#{Rails.env}.lock")
    CONTROL_PATH = Rails.root.join("tmp/simulator-control-#{Rails.env}.lock")
    LOG_PATH = Rails.root.join('log/simulator.log')

    def self.status
      File.open(LOCK_PATH, 'a+') do |lock|
        { running: !lock.flock(File::LOCK_EX | File::LOCK_NB), log: 'log/simulator.log',
          duration_seconds: metadata(lock).fetch('duration_seconds', 360),
          configuration: metadata(lock).fetch('configuration', Configuration.new.to_h) }
      end
    end

    def self.control
      File.open(CONTROL_PATH, 'a') do |control|
        control.flock(File::LOCK_EX)
        yield
      end
    end

    def self.metadata(lock)
      lock.rewind
      value = JSON.parse(lock.read)
      value.is_a?(Hash) ? value : { 'pid' => value, 'duration_seconds' => 360 }
    rescue JSON::ParserError
      { 'pid' => nil, 'duration_seconds' => 360 }
    end

    def self.record_pid(lock, pid, configuration: Configuration.new)
      lock.truncate(0)
      lock.rewind
      lock.write({ pid: pid, host: Socket.gethostname, duration_seconds: configuration.duration_seconds, configuration: configuration.to_h }.to_json)
      lock.flush
    end

    def self.start(options = {})
      raise 'Simulator is development-only' unless Rails.env.development?

      configuration = Configuration.new(**options.symbolize_keys)
      control do
        File.open(LOCK_PATH, 'a+') do |lock|
          raise AlreadyRunning, 'Simulator is already running' unless lock.flock(File::LOCK_EX | File::LOCK_NB)

          existing = Driver.where('email ~ ?', '^sim-driver-[0-9]+@rideshare[.]test$').select(:id)
          if Trip.where(driver_id: existing, completed_at: nil).exists?
            raise AlreadyRunning, 'Unfinished simulator trips remain; use Reset before starting'
          end
          # The child retains the lock through exec; the OS releases it on exit.
          lock.close_on_exec = false
          environment = { 'SIM_LOCK_FD' => lock.fileno.to_s, 'SIM_CONFIG' => configuration.to_h.to_json,
                          'RAILS_MAX_THREADS' => '5' }
          pid = Process.spawn(environment, RbConfig.ruby, Rails.root.join('bin/rails').to_s,
                              "simulate:app_activity[#{configuration.iterations}]", lock.fileno => lock,
                              chdir: Rails.root.to_s, in: File::NULL, out: [LOG_PATH.to_s, 'a'],
                              err: [:child, :out], pgroup: true)
          record_pid(lock, pid, configuration: configuration)
          Process.detach(pid)
        end
      end
      { running: true, log: 'log/simulator.log', configuration: configuration.to_h }
    end

    def self.exclusively(configuration: Configuration.new)
      lock = ENV['SIM_LOCK_FD'] ? File.for_fd(Integer(ENV.fetch('SIM_LOCK_FD'))) : File.open(LOCK_PATH, 'a+')
      control do
        raise AlreadyRunning, 'Simulator is already running' unless lock.flock(File::LOCK_EX | File::LOCK_NB)

        record_pid(lock, Process.pid, configuration: configuration)
      end
      yield
    rescue SignalException => error
      # Terminate all sampling threads before the OS releases the run lock.
      Process.exit!(128 + error.signo)
    ensure
      lock&.close
    end

    def self.reset
      raise 'Simulator is development-only' unless Rails.env.development?

      control do
        File.open(LOCK_PATH, 'a+') do |lock|
          unless lock.flock(File::LOCK_EX | File::LOCK_NB)
            details = metadata(lock)
            pid = Integer(details['pid'], exception: false)
            raise ResetFailed, 'Cannot identify the running task; stop it in its terminal first' unless pid && pid > 1 && pid != Process.pid
            same_environment = details['host'] == Socket.gethostname ||
                               (!details.key?('host') && legacy_task_holds_lock?(pid, lock))
            unless same_environment
              raise ResetFailed, 'Task runs in another environment; stop it in its own terminal/container'
            end

            Process.kill('TERM', pid)
            deadline = Process.clock_gettime(Process::CLOCK_MONOTONIC) + 5
            until lock.flock(File::LOCK_EX | File::LOCK_NB) && !alive?(pid)
              raise ResetFailed, 'Task is still stopping; try Reset again' if Process.clock_gettime(Process::CLOCK_MONOTONIC) >= deadline

              sleep 0.05
            end
          end
          removed = clear_unfinished
          configuration = Configuration.new(**metadata(lock).fetch('configuration', {}).symbolize_keys)
          record_pid(lock, 0, configuration: configuration)
          { running: false, removed_trips: removed }
        end
      end
    rescue Errno::ESRCH
      raise ResetFailed, 'Task exited while resetting; try Reset again'
    end

    # Older runs did not record their container hostname. On Linux, verify both
    # the Rails task command and its inherited lock before signaling that PID.
    def self.legacy_task_holds_lock?(pid, lock)
      arguments = File.binread("/proc/#{pid}/cmdline").split("\0")
      return false unless arguments.include?(Rails.root.join('bin/rails').to_s) &&
                          arguments.any? { |argument| argument.match?(/\Asimulate:app_activity(?:\[.*\])?\z/) }

      Dir.glob("/proc/#{pid}/fd/*").any? do |path|
        File.identical?(path, lock.path)
      rescue Errno::ENOENT, Errno::EACCES
        false
      end
    rescue Errno::ENOENT, Errno::EACCES
      false
    end

    def self.alive?(pid)
      Process.kill(0, pid)
      true
    rescue Errno::ESRCH
      false
    end

    def self.clear_unfinished
      Trip.transaction do
        Trip.connection.execute('SELECT pg_advisory_xact_lock(72493021)')
        drivers = Driver.where('email ~ ?', '^sim-driver-[0-9]+@rideshare[.]test$').select(:id)
        riders = Rider.where('email ~ ?', '^sim-rider-[0-9]+@rideshare[.]test$').select(:id)
        requests = TripRequest.where(rider_id: riders).select(:id)
        trips = Trip.where(driver_id: drivers, trip_request_id: requests, completed_at: nil).lock.to_a
        trips.each do |trip|
          request = trip.trip_request
          if request.vehicle_reservations.exists? || Trip.where(trip_request_id: request.id).where.not(id: trip.id).exists?
            raise ResetFailed, "Trip ##{trip.id} has other linked records; no trip data was reset"
          end
          TripPosition.where(trip_id: trip.id).delete_all
          trip.destroy!
          request.destroy!
        end
        trips.size
      end
    end
  end
end
