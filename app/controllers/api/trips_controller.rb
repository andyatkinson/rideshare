class Api::TripsController < ApiController
  #
  # Search params: `start_location`
  #   => `New%20York%2C%20NY`
  #
  def index
    search = TripSearch.new(search_params)
    trips = Trip.apply_scopes(search.start_location, search.driver_name)

    render json: trips
  end

  private

  def search_params
    params.permit(
      :start_location,
      :driver_name
   )
  end
end
