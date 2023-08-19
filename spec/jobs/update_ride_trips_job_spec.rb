require "rails_helper"

RSpec.describe UpdateRideTripsJob do
  it "enqueues a job to analyze trips" do
    ride = Ride.create!
    driver_1 = Driver.create!
    driver_2 = Driver.create!
    trip = Trip.create(driver: driver_1, ride:)
    trip = Trip.create(driver: driver_2, ride:)

    UpdateRideTripsJob.perform_inline(ride.id)
    expect(AnalyzeTripJob).to have_enqueued_sidekiq_job(ride.trips.first.id)
    expect(AnalyzeTripJob).to have_enqueued_sidekiq_job(ride.trips.last.id)
  end
end
