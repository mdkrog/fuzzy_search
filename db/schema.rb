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

ActiveRecord::Schema.define(version: 2018_07_31_203706) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.string "item_name", null: false
    t.float "lat"
    t.float "lng"
    t.text "item_url"
    t.text "img_urls"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_name"], name: "index_items_on_item_name"
    t.index ["lat"], name: "index_items_on_lat"
    t.index ["lng"], name: "index_items_on_lng"
  end

end
