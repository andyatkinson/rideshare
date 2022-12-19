class Api::TripRequestsController < ApiController
  def create
    if start_location && end_location && current_rider
      trip_request = current_rider.trip_requests.create!(
        start_location: start_location,
        end_location: end_location
      )
      render json: {trip_request_id: trip_request.id}, status: :created
    else
      render nothing: true,
        status: :unprocessable_entity
    end
  end

  def show
    if current_trip_request
      render json: {
        trip_request_id: current_trip_request.id
      }
    else
      render nothing: true,
        status: :unprocessable_entity
    end
  end

  private

  def trip_request_params
    params.
      require(:trip_request).
      permit(:rider_id, :start_address, :end_address)
  end

  def current_trip_request
    @trip_request ||= TripRequest.find(params[:id])
  end

  def current_rider
    @rider ||= Rider.find(trip_request_params[:rider_id])
  end

  def start_location
    @start_location ||= Location.find_or_create_by(
      address: trip_request_params[:start_address]
    )
  end

  def end_location
    @end_location ||= Location.find_or_create_by(
      address: trip_request_params[:end_address]
    )
  end
end
