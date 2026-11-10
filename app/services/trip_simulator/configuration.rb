class TripSimulator
  class Configuration
    attr_reader :concurrency, :sample_interval, :jitter_seconds, :duration_seconds, :iterations

    def initialize(concurrency: 1, sample_interval: 5, jitter_seconds: 30, duration_seconds: 360, iterations: 10)
      @concurrency = Integer(concurrency.to_s, 10)
      @sample_interval, @jitter_seconds = Float(sample_interval), Float(jitter_seconds)
      @duration_seconds, @iterations = Float(duration_seconds), Integer(iterations.to_s, 10)
      raise ArgumentError, 'Concurrent trips must be between 1 and 10' unless (1..10).cover?(@concurrency)
      raise ArgumentError, 'Sampling interval must be between 0.25 and 60 seconds' unless @sample_interval.finite? && (0.25..60).cover?(@sample_interval)
      raise ArgumentError, 'Jitter must be between 0 and 300 seconds' unless @jitter_seconds.finite? && (0..300).cover?(@jitter_seconds)
      raise ArgumentError, 'Duration must be between 1 and 3600 seconds' unless @duration_seconds.finite? && (1..3600).cover?(@duration_seconds)
      raise ArgumentError, 'Trip count must be between 1 and 1000' unless (1..1000).cover?(@iterations)
    end

    def to_h
      { concurrency: concurrency, sample_interval: sample_interval, jitter_seconds: jitter_seconds,
        duration_seconds: duration_seconds, iterations: iterations }
    end

    def self.from_env(iterations:)
      return new(**JSON.parse(ENV.fetch('SIM_CONFIG')).symbolize_keys.merge(iterations: iterations)) if ENV['SIM_CONFIG']

      new(concurrency: ENV.fetch('SIM_CONCURRENCY', 1), sample_interval: ENV.fetch('SIM_INTERVAL', 5),
          jitter_seconds: ENV.fetch('SIM_JITTER', 30), duration_seconds: ENV.fetch('SIM_DURATION', 360), iterations: iterations)
    end
  end
end
