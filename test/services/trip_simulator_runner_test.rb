require 'test_helper'
require 'minitest/mock'

class TripSimulatorRunnerTest < ActiveSupport::TestCase
  test 'background child retains the run lock and exit releases it' do
    spawn = Process.method(:spawn)
    detach = Process.method(:detach)
    child, waiter = nil, nil
    replacement = lambda do |environment, *arguments, **options|
      options = arguments.last if arguments.last.is_a?(Hash)
      child = spawn.call(environment, RbConfig.ruby, '-e', 'sleep 30', **options)
    end
    Rails.env.stub(:development?, true) do
      Process.stub(:spawn, replacement) do
        Process.stub(:detach, ->(pid) { waiter = detach.call(pid) }) do
          assert TripSimulator::Runner.start[:running]
          assert TripSimulator::Runner.status[:running]
          assert_raises(TripSimulator::Runner::AlreadyRunning) { TripSimulator::Runner.start }
        end
      end
    end
    Process.kill('TERM', child)
    waiter.value
    assert_not TripSimulator::Runner.status[:running]
  ensure
    Process.kill('TERM', child) rescue nil
    waiter&.join
  end
end
