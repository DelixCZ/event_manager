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

ActiveRecord::Schema[8.1].define(version: 2026_08_20_170500) do
  create_table "attendees", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_attendees_on_email", unique: true
  end

  create_table "enrollments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "attendee_id", null: false
    t.datetime "created_at", null: false
    t.bigint "event_id", null: false
    t.string "status", default: "confirmed", null: false
    t.datetime "updated_at", null: false
    t.datetime "waitlisted_at"
    t.index ["attendee_id"], name: "index_enrollments_on_attendee_id"
    t.index ["event_id", "attendee_id"], name: "index_enrollments_on_event_id_and_attendee_id", unique: true
    t.index ["event_id"], name: "index_enrollments_on_event_id"
    t.index ["status"], name: "index_enrollments_on_status"
    t.index ["waitlisted_at"], name: "index_enrollments_on_waitlisted_at"
  end

  create_table "events", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "capacity", default: 10, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.date "end_date", null: false
    t.string "location"
    t.bigint "organizer_id", null: false
    t.date "start_date", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["organizer_id"], name: "index_events_on_organizer_id"
  end

  create_table "organizers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_organizers_on_email", unique: true
  end

  add_foreign_key "enrollments", "attendees"
  add_foreign_key "enrollments", "events"
  add_foreign_key "events", "organizers"
end
