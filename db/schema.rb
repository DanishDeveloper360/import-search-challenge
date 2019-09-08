# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_08_103837) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "port_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "ports", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "city"
    t.string "oceans_insights_code"
    t.decimal "lat"
    t.decimal "lng"
    t.string "big_schedules"
    t.boolean "port_hub"
    t.string "ocean_insights"
    t.bigint "port_type_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_ports_on_code", unique: true
    t.index ["port_type_id"], name: "index_ports_on_port_type_id"
  end

  add_foreign_key "ports", "port_types"
end
