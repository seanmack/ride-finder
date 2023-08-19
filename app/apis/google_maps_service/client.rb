module GoogleMapsService
  class Client
    attr_reader :adapter, :api_key

    BASE_URL = "https://maps.googleapis.com/maps/api/"

    def initialize(
      api_key: Rails.application.credentials.google_maps[:api_key],
      adapter: Faraday.default_adapter,
      stubs: nil
    )
      @api_key = api_key
      @adapter = adapter
      @stubs = stubs
    end

    def connection
      @connection ||= Faraday.new do |conn|
        conn.url_prefix = BASE_URL
        conn.request :json
        conn.response :json, content_type: "application/json"
        conn.adapter adapter, @stubs
      end
    end

    def directions
      Directions.new(self)
    end
  end
end
