class TripSimulator
  # A detached Rails task, not a thread in the reloading web process.
  class Runner
    class AlreadyRunning < StandardError; end
    LOCK_PATH = Rails.root.join("tmp/simulator-#{Rails.env}.lock")
    LOG_PATH = Rails.root.join('log/simulator.log')

    def self.status
      File.open(LOCK_PATH, 'a') do |lock|
        { running: !lock.flock(File::LOCK_EX | File::LOCK_NB), log: 'log/simulator.log' }
      end
    end

    def self.start
      raise 'Simulator is development-only' unless Rails.env.development?

      File.open(LOCK_PATH, 'a') do |lock|
        raise AlreadyRunning, 'Simulator is already running' unless lock.flock(File::LOCK_EX | File::LOCK_NB)

        # The child retains this lock through exec; closing our copy does not
        # unlock it. The OS releases it even if the child is interrupted.
        existing = Driver.where('email ~ ?', '^sim-driver-[0-9]+@rideshare[.]test$').select(:id)
        if Trip.where(driver_id: existing, completed_at: nil).exists?
          raise AlreadyRunning, 'Simulator trips are already active; finish the current run first'
        end
        lock.close_on_exec = false
        environment = { 'SIM_LOCK_FD' => lock.fileno.to_s, 'SIM_DRIVERS' => '5',
                        'SIM_SAMPLES' => '13', 'SIM_INTERVAL' => '30', 'SIM_CONCURRENCY' => '2' }
        pid = Process.spawn(environment, RbConfig.ruby, Rails.root.join('bin/rails').to_s,
                            'simulate:app_activity[10]', lock.fileno => lock,
                            chdir: Rails.root.to_s, in: File::NULL, out: [LOG_PATH.to_s, 'a'],
                            err: [:child, :out], pgroup: true)
        Process.detach(pid)
      end
      { running: true, log: 'log/simulator.log' }
    end

    def self.exclusively
      lock = ENV['SIM_LOCK_FD'] ? File.for_fd(Integer(ENV.fetch('SIM_LOCK_FD'))) : File.open(LOCK_PATH, 'a')
      raise AlreadyRunning, 'Simulator is already running' unless lock.flock(File::LOCK_EX | File::LOCK_NB)

      yield
    ensure
      lock&.close
    end
  end
end
