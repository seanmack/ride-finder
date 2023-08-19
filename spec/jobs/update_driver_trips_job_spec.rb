require "rails_helper"

RSpec.describe UpdateDriverTripsJob do
  it "enqueues a job to analyze trips" do
    driver = Driver.create!
    ride_1 = Ride.create!
    ride_2 = Ride.create!
    trip = Trip.create(ride: ride_1, driver:)
    trip = Trip.create(ride: ride_2, driver:)

    UpdateDriverTripsJob.perform_inline(driver.id)
    expect(AnalyzeTripJob).to have_enqueued_sidekiq_job(driver.trips.first.id)
    expect(AnalyzeTripJob).to have_enqueued_sidekiq_job(driver.trips.last.id)
  end
end
