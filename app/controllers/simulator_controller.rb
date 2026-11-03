class SimulatorController < ApplicationController
  before_action :require_development

  def index
    render layout: false
  end

  def snapshot
    response.headers['Cache-Control'] = 'no-store'
    render json: TripSimulator::Snapshot.new.call
  end

  private

  def require_development
    head :not_found unless Rails.env.development?
  end
end
