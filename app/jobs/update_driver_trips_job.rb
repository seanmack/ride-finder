class UpdateDriverTripsJob
  include Sidekiq::Worker

  def perform(driver_id)
    driver = Driver.find(driver_id)
    update_trips!(driver:)
    true
  end

  private

  def update_trips!(driver:)
    driver.trips.find_each do |trip|
      AnalyzeTripJob.perform_async(trip.id)
    end
  end
end
