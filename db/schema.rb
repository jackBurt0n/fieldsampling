# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170626001135) do

  create_table "appointments", force: true do |t|
    t.integer  "pulls"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "day_id"
    t.integer  "location_id"
  end

  add_index "appointments", ["day_id"], name: "index_appointments_on_day_id"
  add_index "appointments", ["location_id"], name: "index_appointments_on_location_id"

  create_table "days", force: true do |t|
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "days", ["date"], name: "index_days_on_date", unique: true

  create_table "days_locations", force: true do |t|
    t.integer "day_id"
    t.integer "location_id"
  end

  create_table "locations", force: true do |t|
    t.text     "client"
    t.text     "city"
    t.text     "ranchfield"
    t.text     "grower"
    t.text     "siteblock"
    t.text     "variety"
    t.integer  "acres"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
