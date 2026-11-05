class TripSimulator
  # Saved OSRM street geometry; no network calls while generating positions.
  class Route
    def self.path(start, finish)
      start_key = Pool::LOCATIONS.find { |entry| entry[0] == start.address }&.last
      finish_key = Pool::LOCATIONS.find { |entry| entry[0] == finish.address }&.last
      key = "#{start_key}_to_#{finish_key}" if start_key && finish_key
      first = [start.position.x, start.position.y]
      last = [finish.position.x, finish.position.y]
      geometry = key ? routes.fetch(key).fetch('coordinates') : []
      [first, *geometry, last]
    end

    def self.point(start, finish, fraction)
      points = path(start, finish)
      return points.first if fraction.zero?
      return points.last if fraction == 1

      lengths = points.each_cons(2).map do |a, b|
        Math.hypot((b[0] - a[0]), (b[1] - a[1]) * Math.cos((a[0] + b[0]) * Math::PI / 360))
      end
      remaining = lengths.sum * fraction
      points.each_cons(2).zip(lengths).each do |(a, b), length|
        next if length.zero?
        return a.zip(b).map { |x, y| x + (y - x) * remaining / length } if remaining <= length

        remaining -= length
      end
      points.last
    end

    def self.routes
      @routes ||= JSON.parse(File.read(Rails.root.join('db/simulator_routes.json'))).fetch('routes')
    end
  end
end
