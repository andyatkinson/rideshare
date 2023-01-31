class TripSearch
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def start_location
    if text = params[:start_location]
      Trip.with_start_location(sanitize(text))
    else
      Trip.all
    end
  end

  def driver_name
    if text = params[:driver_name]
      Trip.with_driver_name(sanitize(text))
    else
      Trip.all
    end
  end

  def rider_name
    if text = params[:rider_name]
      Trip.with_rider_name(sanitize(text))
    else
      Trip.all
    end
  end

  private

  def sanitize(text)
    CGI.unescape(text.to_s)
  end
end
