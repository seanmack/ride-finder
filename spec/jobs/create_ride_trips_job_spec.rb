require "rails_helper"

RSpec.describe CreateRideTripsJob do
  it "creates trips for a ride" do
    ride = Ride.create!
    Driver.create!
    Driver.create!

    expect do
      CreateRideTripsJob.perform_inline(ride.id)
    end.to change { ride.trips.count }.by(2)
  end

  it "enqueues a job to analyze trips" do
    ride = Ride.create!
    Driver.create!
    Driver.create!

    CreateRideTripsJob.perform_inline(ride.id)
    expect(AnalyzeTripJob).to have_enqueued_sidekiq_job(ride.trips.first.id)
    expect(AnalyzeTripJob).to have_enqueued_sidekiq_job(ride.trips.last.id)
  end
end
