class Api::V1::RidesController < ApplicationController
  include ActionController::Caching
  include Pagy::Backend

  before_action :set_driver

  def index
    rides = RideAnalysisQuery.new.call(driver_id: @driver.id)

    @pagy, @rides = pagy(rides)
    @pagy_metadata = pagy_metadata(@pagy)
  end

  private

  def set_driver
    @driver = Driver.find(params[:driver_id])
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Driver not found"}
  end
end
