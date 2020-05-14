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

  # TODO authentication
  def my
    @trips = Trip.completed.joins(trip_request: :rider).
      where('users.id = ?', params[:rider_id])

    # params[:fields] may be passed from the client as an array of Strings
    options = {}
    options.merge!(fields: { trip: params[:fields] }) if params[:fields].present?

    render json: TripSerializer.new(@trips, options).serializable_hash
  end

  private

  def search_params
    params.permit(
      :start_location,
      :driver_name,
      :rider_name
   )
  end
end
