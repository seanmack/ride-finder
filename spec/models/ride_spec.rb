require "rails_helper"

RSpec.describe Ride, type: :model do
  it do
    should have_db_column(:pick_up_address)
      .of_type(:jsonb)
      .with_options(default: {})
  end

  it do
    should have_db_column(:drop_off_address)
      .of_type(:jsonb)
      .with_options(default: {})
  end

  it { should have_many(:trips) }

  it "should create trips after create" do
    ride = Ride.create!
    expect(CreateRideTripsJob).to have_enqueued_sidekiq_job(ride.id)
  end

  it "should update trips after changing pick_up_address" do
    ride = Ride.create!
    ride.update!(pick_up_address: {city: "Los Angeles"})
    expect(UpdateRideTripsJob).to have_enqueued_sidekiq_job(ride.id)
  end

  it "should update trips after changing drop_off_address" do
    ride = Ride.create!
    ride.update!(drop_off_address: {city: "Los Angeles"})
    expect(UpdateRideTripsJob).to have_enqueued_sidekiq_job(ride.id)
  end

  it "should not update trips when pick_up_address or drop_off_address are unchanged" do
    ride = Ride.create!(
      pick_up_address: {city: "Los Angeles"},
      drop_off_address: {city: "New York"}
    )

    ride.update!(
      pick_up_address: {city: "Los Angeles"},
      drop_off_address: {city: "New York"}
    )

    expect(UpdateRideTripsJob).not_to have_enqueued_sidekiq_job(ride.id)
  end
end
