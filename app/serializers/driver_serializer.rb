class DriverSerializer
  include FastJsonapi::ObjectSerializer

  extend ActionView::Helpers::NumberHelper

  attribute :display_name

  attribute :average_rating do |driver|
    number_to_percentage(
      driver.average_rating,
      precision: 2
    )
  end
end
