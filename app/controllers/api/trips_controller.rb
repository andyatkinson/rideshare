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
    @trips = Trip.completed.
      includes(:driver, {trip_request: :rider}).
      joins(trip_request: :rider).
      where('users.id = ?', params[:rider_id])

    options = {}
    # JSON API: https://jsonapi.org/format/#fetching-sparse-fieldsets
    # fast_jsonapi: https://github.com/Netflix/fast_jsonapi#sparse-fieldsets
    #
    # convert input params to options arguments
    if params[:fields]
      trip_params = params[:fields].permit(:trips).to_h.
        inject({}) { |h, (k,v)| h[k.singularize.to_sym] = v.split(",").map(&:to_sym); h }
      options.merge!(fields: trip_params)
    end

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
