class TripSimulator
  class Pool
    LOCATIONS = [
      ['Kendall Square, Cambridge, MA', 'MA', [42.36242, -71.08572]],
      ['Central Square, Cambridge, MA', 'MA', [42.36507, -71.10310]]
    ].freeze

    attr_reader :drivers, :riders, :locations

    def initialize(driver_count: 10, rider_count: 30)
      @driver_count, @rider_count = Integer(driver_count), Integer(rider_count)
      raise ArgumentError, 'Pool sizes must be positive' unless @driver_count.positive? && @rider_count.positive?
    end

    def prepare!
      User.transaction do
        @drivers = actors(Driver, @driver_count)
        @riders = actors(Rider, @rider_count)
        @locations = LOCATIONS.map do |address, state, position|
          Location.find_or_create_by!(address: address) do |location|
            location.state, location.position = state, position
          end
        end
      end
      self
    end

    private

    def actors(type, count)
      (1..count).map do |number|
        type.find_or_create_by!(email: "sim-#{type.name.downcase}-#{number}@rideshare.test") do |actor|
          actor.first_name = 'Simulator'
          actor.last_name = "#{type.name} #{number}"
          actor.password = SecureRandom.hex(16)
          actor.drivers_license_number = format('S%012d', number) if type == Driver
        end
      end
    end
  end
end
