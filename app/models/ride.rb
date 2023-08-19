class Ride < ApplicationRecord
  has_many :trips

  after_create :create_trips!
  after_update :update_trips!

  private

  def create_trips!
    CreateRideTripsJob.perform_async(id)
  end

  def update_trips!
    if pick_up_address_changed? || drop_off_address_changed?
      UpdateRideTripsJob.perform_async(id)
    end
  end

  def update_trips!
    if saved_change_to_pick_up_address? || saved_change_to_drop_off_address?
      UpdateRideTripsJob.perform_async(id)
    end
  end
end
