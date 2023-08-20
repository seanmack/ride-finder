class RemoveCommuteDistanceFromTrips < ActiveRecord::Migration[7.0]
  def change
    remove_column :trips, :commute_distance, :integer
  end
end
