class CreateRideTripsJob
  include Sidekiq::Worker

  def perform(ride_id)
    ride = Ride.find(ride_id)
    create_trips_for_existing_drivers!(ride:)
    ride
  end

  private

  def create_trips_for_existing_drivers!(ride:)
    Driver.find_each do |driver|
      trip = Trip.find_or_create_by!(
        driver_id: driver.id,
        ride_id: ride.id
      )

      # Create a child job to populate trip metrics for newly created records
      analyze_trip(trip:) if trip.created_at == trip.updated_at
    end
  end

  def analyze_trip(trip:)
    AnalyzeTripJob.perform_async(trip.id)
  end
end
