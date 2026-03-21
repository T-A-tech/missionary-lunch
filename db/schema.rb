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

ActiveRecord::Schema[7.2].define(version: 2024_01_01_000004) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "ward_id", null: false
    t.date "scheduled_date", null: false
    t.string "family_name", null: false
    t.string "phone"
    t.boolean "reminder_sent", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ward_id", "scheduled_date"], name: "index_appointments_on_ward_id_and_scheduled_date", unique: true
    t.index ["ward_id"], name: "index_appointments_on_ward_id"
  end

  create_table "stakes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "wards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "stake_id", null: false
    t.uuid "user_id", null: false
    t.string "name", null: false
    t.string "public_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["public_token"], name: "index_wards_on_public_token", unique: true
    t.index ["stake_id"], name: "index_wards_on_stake_id"
    t.index ["user_id"], name: "index_wards_on_user_id"
  end

  add_foreign_key "appointments", "wards"
  add_foreign_key "wards", "stakes"
  add_foreign_key "wards", "users"
end
