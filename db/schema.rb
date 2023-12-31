# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_08_20_005504) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "drivers", force: :cascade do |t|
    t.jsonb "address", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rides", force: :cascade do |t|
    t.jsonb "pick_up_address", default: {}
    t.jsonb "drop_off_address", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trips", force: :cascade do |t|
    t.bigint "driver_id", null: false
    t.bigint "ride_id", null: false
    t.integer "score", default: 0
    t.integer "commute_duration", default: 0
    t.integer "ride_distance", default: 0
    t.integer "ride_duration", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id", "ride_id"], name: "index_trips_on_driver_id_and_ride_id", unique: true
    t.index ["driver_id"], name: "index_trips_on_driver_id"
    t.index ["ride_id"], name: "index_trips_on_ride_id"
  end

  add_foreign_key "trips", "drivers", on_delete: :cascade
  add_foreign_key "trips", "rides", on_delete: :cascade
end
