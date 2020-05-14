class Api::TripsController < ApiController
  #
  # Search params: `start_location`
  #   => `New%20York%2C%20NY`
  #
  def index
    search = TripSearch.new(search_params)
    trips = Trip.apply_scopes(
      search.start_location,
      search.driver_name,
      search.rider_name
    )

    render json: trips
  end

  def show
    expires_in 1.minute, public: true

    @trip = Trip.find(params[:id])

    if stale?(@trip)
      render json: @trip
    end
  end

  private

  def search_params
    params.permit(
      :id,
      :start_location,
      :driver_name,
      :rider_name
   )
  end
end
