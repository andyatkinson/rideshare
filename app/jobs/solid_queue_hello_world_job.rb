class SolidQueueHelloWorldJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.info "solid queue hello world"
  end
end
