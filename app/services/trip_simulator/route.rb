class TripSimulator
  # Saved OSRM street geometry; no network calls while generating positions.
  class Route
    def self.point(start, finish, fraction)
      key = if start.address == Pool::LOCATIONS[0][0] && finish.address == Pool::LOCATIONS[1][0]
              'kendall_to_central'
            elsif start.address == Pool::LOCATIONS[1][0] && finish.address == Pool::LOCATIONS[0][0]
              'central_to_kendall'
            end
      first = [start.position.x, start.position.y]
      last = [finish.position.x, finish.position.y]
      return first if fraction.zero?
      return last if fraction == 1

      geometry = key ? routes.fetch(key).fetch('coordinates') : []
      points = [first, *geometry, last]
      lengths = points.each_cons(2).map do |a, b|
        Math.hypot((b[0] - a[0]), (b[1] - a[1]) * Math.cos((a[0] + b[0]) * Math::PI / 360))
      end
      remaining = lengths.sum * fraction
      points.each_cons(2).zip(lengths).each do |(a, b), length|
        next if length.zero?
        return a.zip(b).map { |x, y| x + (y - x) * remaining / length } if remaining <= length

        remaining -= length
      end
      last
    end

    def self.routes
      @routes ||= JSON.parse(File.read(Rails.root.join('db/simulator_routes.json'))).fetch('routes')
    end
  end
end
