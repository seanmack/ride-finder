require "rails_helper"

RSpec.describe GoogleMapsService::Client do
  it "should initialize with default adapter" do
    client = GoogleMapsService::Client.new
    expect(client.adapter).to eq(Faraday.default_adapter)
  end

  it "should initialize with a default api_key" do
    client = GoogleMapsService::Client.new
    expect(client.api_key).to eq("default_key")
  end

  it "should let me set an api_key" do
    client = GoogleMapsService::Client.new(api_key: "new_key")
    expect(client.api_key).to eq("new_key")
  end
end
