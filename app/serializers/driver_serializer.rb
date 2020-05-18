class DriverSerializer
  include FastJsonapi::ObjectSerializer

  attribute :display_name

  attribute :average_rating do |driver|
    driver.average_rating.round(2)
  end
end
