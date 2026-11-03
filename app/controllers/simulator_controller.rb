class SimulatorController < ApplicationController
  before_action :require_development

  def index
    render layout: false
  end

  def snapshot
    response.headers['Cache-Control'] = 'no-store'
    render json: TripSimulator::Snapshot.new.call
  end

  def positions
    trip = TripSimulator::Snapshot.trips.find(params[:id])
    response.headers['Cache-Control'] = 'no-store'
    render json: { id: trip.id, positions: trip.trip_positions.order(:created_at, :id).map { |record| TripSimulator::Snapshot.position(record) } }
  end

  private

  def require_development
    head :not_found unless Rails.env.development?
  end
end
