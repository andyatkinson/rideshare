class TripSearch
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def start_location
    if text = sanitize(params[:start_location])
      Trip.with_start_location(text)
    else
      Trip.all
    end
  end

  def driver_name
    if text = sanitize(params[:driver_name])
      Trip.with_driver_name(text)
    else
      Trip.all
    end
  end

  private

  def sanitize(text)
    URI.unescape(text.to_s)
  end
end
