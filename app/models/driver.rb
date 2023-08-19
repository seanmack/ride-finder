class Driver < ApplicationRecord
  has_many :trips

  after_create :create_trips!
  after_update :update_trips!

  private

  def create_trips!
    CreateDriverTripsJob.perform_async(id)
  end

  def update_trips!
    if saved_change_to_address?
      UpdateDriverTripsJob.perform_async(id)
    end
  end
end
