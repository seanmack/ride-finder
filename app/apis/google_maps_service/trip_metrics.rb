module GoogleMapsService
  class TripMetrics
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def commute_duration_in_minutes
      data.dig("routes", 0, "legs", 0, "duration", "value")
    end

    def ride_duration_in_minutes
      data.dig("routes", 0, "legs", 1, "duration", "value")
    end

    def ride_distance_in_meters
      data.dig("routes", 0, "legs", 1, "distance", "value")
    end
  end
end
