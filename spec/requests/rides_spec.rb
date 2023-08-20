require "rails_helper"

RSpec.describe "Rides", type: :request do
  describe "GET api/v1/rides" do
    it "responds with a 200" do
      get api_v1_rides_path
      expect(response).to have_http_status(200)
    end

    it "returns a list of rides" do
      driver = Driver.create!

      3.times do
        ride = Ride.create!
        Trip.create!(driver: driver, ride: ride)
      end

      get api_v1_rides_path, params: {driver_id: driver.id}

      expect(rides_data.length).to eq(3)
    end

    it "returns ride details" do
      driver = Driver.create!
      ride = Ride.create!
      Trip.create!(driver: driver, ride: ride, score: 1000)

      get api_v1_rides_path, params: {driver_id: driver.id}

      ride_data = rides_data.first

      expect(ride_data["driver_id"]).to eq(driver.id)
      expect(ride_data["ride_id"]).to eq(ride.id)
      expect(ride_data["score"]).to eq("$10.00")
    end

    it "provides pagination" do
      ride_count = Pagy::DEFAULT[:items] + 1
      driver = Driver.create!

      ride_count.times do
        ride = Ride.create!
        Trip.create!(driver: driver, ride: ride)
      end

      get api_v1_rides_path, params: {driver_id: driver.id}

      expect(pagination_data["current_page"]).to eq(1)
      expect(pagination_data["next_page"]).to eq(2)
      expect(pagination_data["next_url"]).to eq("/api/v1/rides?driver_id=#{driver.id}&page=2")
      expect(pagination_data["prev_url"]).to eq("/api/v1/rides?driver_id=#{driver.id}&page=")
      expect(pagination_data["total_records_count"]).to eq(ride_count)
    end

    it "returns an error message if driver is not found" do
      get api_v1_rides_path, params: {driver_id: 1}
      expect(json["error"]).to eq("Driver not found")
    end

    it "returns an empty array if driver has no rides" do
      driver = Driver.create!
      get api_v1_rides_path, params: {driver_id: driver.id}
      expect(rides_data).to eq([])
    end
  end

  def pagination_data
    json["paging"]
  end

  def rides_data
    json["data"]
  end

  def json
    JSON.parse(response.body)
  end
end
