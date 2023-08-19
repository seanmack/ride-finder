require "rails_helper"

RSpec.describe GoogleMapsService::Directions do
  describe "#get_request" do
    it "returns an HTTP response" do
      stub = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get("http://example.com") do |env|
          expect(env.url.query).to include("a=1")
          expect(env.url.query).to include("key=fake")
          [
            200,
            {"Content-Type": "application/json"},
            File.read("spec/fixtures/google_maps_service/directions.json")
          ]
        end
      end

      client = GoogleMapsService::Client.new(
        api_key: "fake",
        adapter: :test,
        stubs: stub
      )

      instance = GoogleMapsService::Resource.new(client)

      response = instance.get_request(
        url: "http://example.com",
        params: {a: 1}
      )

      expect(response).to be_a(Faraday::Response)
    end

    it "handles 500 errors" do
      stub = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get("http://example.com") do |env|
          [
            500,
            {"Content-Type": "application/json"},
            ""
          ]
        end
      end

      client = GoogleMapsService::Client.new(
        api_key: "fake",
        adapter: :test,
        stubs: stub
      )

      instance = GoogleMapsService::Resource.new(client)

      expect do
        instance.get_request(url: "http://example.com")
      end.to raise_error(GoogleMapsService::Error)
    end
  end
end
