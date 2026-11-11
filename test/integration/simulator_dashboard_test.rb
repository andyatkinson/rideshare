require 'test_helper'
require 'minitest/mock'

class SimulatorDashboardTest < ActionDispatch::IntegrationTest
  test 'dashboard is unavailable outside development' do
    get '/simulator'
    assert_response :not_found
    get '/simulator/snapshot'
    assert_response :not_found
    post '/simulator/start'
    assert_response :not_found
    post '/simulator/reset'
    assert_response :not_found
    get '/simulator/trips/1/positions'
    assert_response :not_found
  end

  test 'start returns accepted and repeated starts return conflict' do
    Rails.env.stub(:development?, true) do
      TripSimulator::Runner.stub(:reset, { running: false, removed_trips: 2 }) do
        post '/simulator/reset'
        assert_response :success
        assert_equal 2, response.parsed_body['removed_trips']
      end
      received = nil
      TripSimulator::Runner.stub(:start, ->(options) { received = options; { running: true } }) do
        post '/simulator/start', params: { concurrency: 8, sample_interval: 2, jitter_seconds: 15 }, as: :json
        assert_response :accepted
        assert_equal({ 'concurrency' => 8, 'sample_interval' => 2, 'jitter_seconds' => 15 }, received)
        assert response.parsed_body['running']
      end
      post '/simulator/start', params: { concurrency: 11 }, as: :json
      assert_response :unprocessable_entity
      TripSimulator::Runner.stub(:start, ->(*) { raise TripSimulator::Runner::AlreadyRunning, 'Already running' }) do
        post '/simulator/start'
        assert_response :conflict
      end
    end
  end
end
