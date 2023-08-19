class UpdateRideTripsJob
  include Sidekiq::Worker

  def perform(ride_id)
    ride = Ride.find(ride_id)
    update_trips!(ride:)
    true
  end

  private

  def update_trips!(ride:)
    ride.trips.find_each do |trip|
      AnalyzeTripJob.perform_async(trip.id)
    end
  end
end
