# Inspiration: https://twitter.com/kukicola/status/1578842934849724416
class SlowQuerySubscriber < ActiveSupport::Subscriber
  SECONDS_THRESHOLD = 1.0

  ActiveSupport::Notifications.subscribe('sql.active_record') do |name, start, finish, unique_id, data|
    duration = finish - start

    if duration > SECONDS_THRESHOLD
      sql = data[:sql]
      Rails.logger.info "[#{name}] #{duration} #{sql}"
    end
  end
end
