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
          duration_seconds: metadata(lock).fetch('duration_seconds', 360) }
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

    def self.record_pid(lock, pid, samples: ENV.fetch('SIM_SAMPLES', 73), interval: ENV.fetch('SIM_INTERVAL', 5))
      lock.truncate(0)
      lock.rewind
      lock.write({ pid: pid, duration_seconds: (Integer(samples) - 1) * Float(interval) }.to_json)
      lock.flush
    end

    def self.start
      raise 'Simulator is development-only' unless Rails.env.development?

      control do
        File.open(LOCK_PATH, 'a+') do |lock|
          raise AlreadyRunning, 'Simulator is already running' unless lock.flock(File::LOCK_EX | File::LOCK_NB)

          existing = Driver.where('email ~ ?', '^sim-driver-[0-9]+@rideshare[.]test$').select(:id)
          if Trip.where(driver_id: existing, completed_at: nil).exists?
            raise AlreadyRunning, 'Unfinished simulator trips remain; use Reset before starting'
          end
          # The child retains the lock through exec; the OS releases it on exit.
          lock.close_on_exec = false
          environment = { 'SIM_LOCK_FD' => lock.fileno.to_s, 'SIM_DRIVERS' => '5',
                          'SIM_SAMPLES' => '73', 'SIM_INTERVAL' => '5' }
          pid = Process.spawn(environment, RbConfig.ruby, Rails.root.join('bin/rails').to_s,
                              'simulate:app_activity[10]', lock.fileno => lock,
                              chdir: Rails.root.to_s, in: File::NULL, out: [LOG_PATH.to_s, 'a'],
                              err: [:child, :out], pgroup: true)
          record_pid(lock, pid, samples: 73, interval: 5)
          Process.detach(pid)
        end
      end
      { running: true, log: 'log/simulator.log' }
    end

    def self.exclusively
      lock = ENV['SIM_LOCK_FD'] ? File.for_fd(Integer(ENV.fetch('SIM_LOCK_FD'))) : File.open(LOCK_PATH, 'a+')
      control do
        raise AlreadyRunning, 'Simulator is already running' unless lock.flock(File::LOCK_EX | File::LOCK_NB)

        record_pid(lock, Process.pid)
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
            pid = Integer(metadata(lock)['pid'], exception: false)
            raise ResetFailed, 'Cannot identify the running task; stop it in its terminal first' unless pid && pid > 1 && pid != Process.pid

            Process.kill('TERM', pid)
            deadline = Process.clock_gettime(Process::CLOCK_MONOTONIC) + 5
            until lock.flock(File::LOCK_EX | File::LOCK_NB) && !alive?(pid)
              raise ResetFailed, 'Task is still stopping; try Reset again' if Process.clock_gettime(Process::CLOCK_MONOTONIC) >= deadline

              sleep 0.05
            end
          end
          removed = clear_unfinished
          record_pid(lock, 0)
          { running: false, removed_trips: removed }
        end
      end
    rescue Errno::ESRCH
      raise ResetFailed, 'Task exited while resetting; try Reset again'
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
