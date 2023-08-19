class CreateTrips < ActiveRecord::Migration[7.0]
  def change
    create_table :trips do |t|
      t.references :driver, null: false, foreign_key: {on_delete: :cascade}
      t.references :ride, null: false, foreign_key: {on_delete: :cascade}
      t.integer :score, default: 0
      t.integer :commute_distance, default: 0
      t.integer :commute_duration, default: 0
      t.integer :ride_distance, default: 0
      t.integer :ride_duration, default: 0
      t.timestamps

      t.index [:driver_id, :ride_id], unique: true
    end
  end
end
