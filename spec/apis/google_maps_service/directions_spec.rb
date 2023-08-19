require "rails_helper"

RSpec.describe GoogleMapsService::Directions do
  describe "#get" do
    it "returns trip metrics" do
      origin = "New York, NY"
      destination = "Los Angeles, CA"
      waypoints = ["Philadelphia, PA", "Phoenix, AZ"]

      stub = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get("https://maps.googleapis.com/maps/api/directions/json") do |env|
          expect(env.url.query).to include("origin=New+York%2C+NY")
          expect(env.url.query).to include("destination=Los+Angeles%2C+CA")
          expect(env.url.query).to include("waypoints=Philadelphia%2C+PA%7CPhoenix%2C+AZ")
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

      trip_metrics = client.directions.get(
        origin: origin,
        destination: destination,
        waypoints: waypoints
      )

      expect(trip_metrics).to be_a(GoogleMapsService::TripMetrics)
    end
  end

  it "returns nil if missing params" do
    client = GoogleMapsService::Client.new(
      api_key: "fake",
      adapter: :test
    )

    response = client.directions.get(
      origin: nil,
      destination: nil,
      waypoints: nil
    )

    expect(response).to be(nil)
  end
end
