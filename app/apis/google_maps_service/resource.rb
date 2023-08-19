module GoogleMapsService
  class Resource
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def get_request(url:, params: {})
      merged_params = default_params.merge(params)
      response = client.connection.get(url, merged_params)
      handle_response(response:)
    end

    private

    def default_params
      {key: client.api_key}
    end

    # Example of how specific API errors can be handled
    def handle_response(response:)
      case response.status
      when 500
        raise Error, "Something went wrong with the server"
      end

      response
    end
  end
end
