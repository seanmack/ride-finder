require "rails_helper"

RSpec.describe Driver, type: :model do
  it do
    should have_db_column(:address)
      .of_type(:jsonb)
      .with_options(default: {})
  end

  it { should have_many(:trips) }

  it "should create trips after create" do
    driver = Driver.create!
    expect(CreateDriverTripsJob).to have_enqueued_sidekiq_job(driver.id)
  end

  it "should update trips after saving address" do
    driver = Driver.create!(address: {city: "New York"})
    driver.update!(address: {city: "Los Angeles"})
    expect(UpdateDriverTripsJob).to have_enqueued_sidekiq_job(driver.id)
  end

  it "should not update trips if address has not changed" do
    driver = Driver.create!(address: {city: "New York"})
    driver.update!(address: {city: "New York"})
    expect(UpdateDriverTripsJob).not_to have_enqueued_sidekiq_job(driver.id)
  end
end
