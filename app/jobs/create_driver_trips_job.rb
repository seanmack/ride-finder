class CreateDriverTripsJob
  include Sidekiq::Worker

  def perform(driver_id)
    driver = Driver.find(driver_id)
    create_trips!(driver:)
    driver
  end

  private

  def create_trips!(driver:)
    Ride.find_each do |ride|
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
