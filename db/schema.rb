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

ActiveRecord::Schema[8.0].define(version: 2025_05_17_090834) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.integer "ticket_number"
    t.integer "reservation_reference"
    t.date "reservation_date"
    t.time "reservation_time"
    t.decimal "price"
    t.string "product_type"
    t.string "sales_channel"
    t.bigint "buyer_id", null: false
    t.bigint "performance_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_bookings_on_buyer_id"
    t.index ["performance_id"], name: "index_bookings_on_performance_id"
    t.index ["reservation_reference"], name: "index_bookings_on_reservation_reference"
    t.index ["ticket_number"], name: "index_bookings_on_ticket_number", unique: true
  end

  create_table "buyers", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "email"
    t.string "address"
    t.integer "postal_code"
    t.string "country"
    t.integer "age"
    t.string "gender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_buyers_on_email", unique: true
  end

  create_table "import_jobs", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.integer "processed_rows"
    t.integer "total_rows"
    t.text "error_log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "performances", force: :cascade do |t|
    t.integer "external_id"
    t.bigint "show_id", null: false
    t.string "title"
    t.date "start_date"
    t.time "start_time"
    t.date "end_date"
    t.time "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_performances_on_external_id", unique: true
    t.index ["show_id"], name: "index_performances_on_show_id"
  end

  create_table "raw_import_rows", force: :cascade do |t|
    t.bigint "import_job_id", null: false
    t.jsonb "data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["import_job_id"], name: "index_raw_import_rows_on_import_job_id"
  end

  create_table "shows", force: :cascade do |t|
    t.integer "external_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_shows_on_external_id", unique: true
  end

  add_foreign_key "bookings", "buyers"
  add_foreign_key "bookings", "performances"
  add_foreign_key "performances", "shows"
  add_foreign_key "raw_import_rows", "import_jobs"
end
