class CreateDrivers < ActiveRecord::Migration[7.0]
  def change
    create_table :drivers do |t|
      t.jsonb :address, default: {}
      t.timestamps
    end
  end
end
