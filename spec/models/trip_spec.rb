require "rails_helper"

RSpec.describe Trip, type: :model do
  context "database" do
    it { should have_db_column(:driver_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:ride_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:score).of_type(:integer).with_options(default: 0) }
    it { should have_db_column(:commute_duration).of_type(:integer).with_options(default: 0) }
    it { should have_db_column(:ride_distance).of_type(:integer).with_options(default: 0) }
    it { should have_db_column(:ride_duration).of_type(:integer).with_options(default: 0) }
    it { should have_db_index([:driver_id, :ride_id]).unique(true) }
  end

  context "associations" do
    it { should belong_to(:driver) }
    it { should belong_to(:ride) }
  end

  context "callbacks" do
    it "should create a trip if both a ride and a driver exist" do
      trip = create_trip
      expect(trip).to be_valid
    end

    it "should not create a trip if a ride doesn't exist" do
      driver = Driver.create!
      trip = Trip.create(driver: driver)

      expect(trip).not_to be_valid
    end

    it "should not create a trip if a driver doesn't exist" do
      ride = Ride.create!
      trip = Trip.create(ride: ride)

      expect(trip).not_to be_valid
    end

    it "should destroy a trip if a ride is destroyed" do
      ride = Ride.create!
      driver = Driver.create!
      trip = Trip.create(ride: ride, driver: driver)

      ride.delete

      expect { trip.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "should destroy a trip if a driver is destroyed" do
      ride = Ride.create!
      driver = Driver.create!
      trip = Trip.create(ride: ride, driver: driver)

      driver.delete

      expect { trip.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "validations" do
    it "should validate uniqueness of ride_id scoped to driver_id" do
      ride = Ride.create!
      driver = Driver.create!
      Trip.create!(ride: ride, driver: driver)

      trip = Trip.new(ride: ride, driver: driver)
      expect(trip).not_to be_valid
    end
  end

  context "scopes" do
    it "should return trips in descending order of score" do
      trip1 = create_trip
      trip2 = create_trip
      trip3 = create_trip

      trip1.update!(score: 100)
      trip2.update!(score: 200)
      trip3.update!(score: 300)

      expect(Trip.order_by_score_desc).to eq([trip3, trip2, trip1])
    end
  end

  context "trip metrics" do
    it "should compile trip metrics after create" do
      trip = create_trip
      expect(AnalyzeTripJob).to have_enqueued_sidekiq_job(trip.id)
    end

    it "calculates a score in cents per hour for long rides" do
      trip = create_trip
      expect(trip.score).to eq(0)

      trip.commute_duration = 1
      trip.ride_distance = 11265 # about 7 miles
      trip.ride_duration = 18 # minutes
      trip.calculate_score
      trip.save!

      expect(trip.score).to eq(5400)
    end

    it "calculates a score in cents per hour for short rides" do
      trip = create_trip
      expect(trip.score).to eq(0)

      trip.commute_duration = 1
      trip.ride_distance = 6437 # about 4 miles
      trip.ride_duration = 8 # minutes
      trip.calculate_score
      trip.save!

      expect(trip.score).to eq(8000)
    end
  end

  def create_trip
    ride = Ride.create!
    driver = Driver.create!
    Trip.create(ride: ride, driver: driver)
  end
end
