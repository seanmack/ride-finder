module GoogleMapsService
  class Directions < Resource
    def get(origin:, destination:, waypoints: [])
      return if invalid_params(origin, destination)

      location_params = format_location_params(origin:, destination:, waypoints:)

      response = get_request(url: "directions/json", params: location_params)
      parse_api_response(response)
    end

    private

    def format_location_params(origin:, destination:, waypoints:)
      formatted_waypoints = format_waypoints(waypoints:)

      {
        origin: origin,
        destination: destination,
        waypoints: formatted_waypoints
      }
    end

    def format_waypoints(waypoints:)
      waypoints.join("|")
    end

    def parse_api_response(response)
      TripMetrics.new(response.body)
    end

    def invalid_params(*args)
      args.any?(&:nil?)
    end
  end
end
