require "rails_helper"

RSpec.describe GoogleMapsService::TripMetrics do
  it "parses data retrieved from Google Maps API" do
    trip_metrics = GoogleMapsService::TripMetrics.new(load_data)
    expect(trip_metrics.commute_duration_in_minutes).to eq(2960)
    expect(trip_metrics.ride_distance_in_meters).to eq(74992)
    expect(trip_metrics.ride_duration_in_minutes).to eq(3713)
  end

  def load_data
    JSON.parse(File.read("spec/fixtures/google_maps_service/directions.json"))
  end
end
