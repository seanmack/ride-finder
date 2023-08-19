require "rails_helper"

RSpec.describe CreateDriverTripsJob do
  it "creates trips for a driver" do
    driver = Driver.create!
    ride_1 = Ride.create!
    ride_2 = Ride.create!

    expect do
      CreateDriverTripsJob.perform_inline(driver.id)
    end.to change { driver.trips.count }.by(2)
  end

  it "enqueues a job to analyze trips" do
    driver = Driver.create!
    ride_1 = Ride.create!
    ride_2 = Ride.create!

    CreateDriverTripsJob.perform_inline(driver.id)
    expect(AnalyzeTripJob).to have_enqueued_sidekiq_job(driver.trips.first.id)
    expect(AnalyzeTripJob).to have_enqueued_sidekiq_job(driver.trips.last.id)
  end
end
