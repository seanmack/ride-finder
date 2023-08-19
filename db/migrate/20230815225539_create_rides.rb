class CreateRides < ActiveRecord::Migration[7.0]
  def change
    create_table :rides do |t|
      t.jsonb :pick_up_address, default: {}
      t.jsonb :drop_off_address, default: {}
      t.timestamps
    end
  end
end
