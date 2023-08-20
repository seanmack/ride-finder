class AnalyzeTripJob
  include Sidekiq::Worker

  def perform(trip_id)
    trip = Trip.find(trip_id)
    locations = format_locations(driver: trip.driver, ride: trip.ride)
    trip_metrics = call_google_maps_api(locations:)
    update_trip!(trip:, trip_metrics:)
  end

  private

  def format_locations(driver:, ride:)
    {
      origin: format_address(driver.address),
      waypoints: format_address(ride.pick_up_address),
      destination: format_address(ride.drop_off_address)
    }
  end

  def call_google_maps_api(locations:)
    client = GoogleMapsService::Client.new

    client.directions.get(
      origin: locations[:origin],
      destination: locations[:destination],
      waypoints: [locations[:waypoints]]
    )
  end

  def update_trip!(trip:, trip_metrics:)
    trip.ride_distance = trip_metrics.ride_distance_in_meters
    trip.ride_duration = trip_metrics.ride_duration_in_minutes
    trip.commute_duration = trip_metrics.commute_duration_in_minutes
    trip.calculate_score
    trip.save!
  end

  def format_address(address)
    string = "#{address["street_1"]}, #{address["street_2"]} #{address["city"]}, #{address["state"]} #{address["zip_code"]}"
    string.squish
  end
end
