require "rails_helper"
require "ostruct"

RSpec.describe AnalyzeTripJob do
  it "analyzes a trip using metrics retrieved from the Google Maps API" do
    driver = create_driver
    ride = create_ride
    trip = create_trip(driver:, ride:)

    mock_client = instance_double("GoogleMapsService::Client")
    mock_directions = double("Directions")

    allow(GoogleMapsService::Client).to receive(:new).and_return(mock_client)
    allow(mock_client).to receive(:directions).and_return(mock_directions)

    expect(mock_directions).to receive(:get).with(
      origin: "777 Brockton Avenue, Apt 1 Abington, MA",
      destination: "677 Timpany Blvd, Gardner, MA",
      waypoints: ["121 Worcester Rd, Framingham, MA"]
    ).and_return(mock_response)

    AnalyzeTripJob.perform_inline(trip.id)

    trip.reload
    expect(trip.ride_distance).to eq(1)
    expect(trip.ride_duration).to eq(2)
    expect(trip.commute_duration).to eq(3)
    expect(trip.score).to eq(14400)
  end

  def create_driver
    Driver.create!(
      address: {
        street_1: "777 Brockton Avenue",
        street_2: "Apt 1",
        city: "Abington",
        state: "MA",
        zip: "2351"
      }
    )
  end

  def create_ride
    Ride.create!(
      pick_up_address: {street_1: "121 Worcester Rd", street_2: "", city: "Framingham", state: "MA", zip: "1701"},
      drop_off_address: {street_1: "677 Timpany Blvd", street_2: "", city: "Gardner", state: "MA", zip: "1440"}
    )
  end

  def create_trip(driver:, ride:)
    Trip.create!(driver_id: driver.id, ride_id: ride.id)
  end

  def mock_response
    OpenStruct.new(
      ride_distance_in_meters: 1,
      ride_duration_in_minutes: 2,
      commute_duration_in_minutes: 3
    )
  end
end
