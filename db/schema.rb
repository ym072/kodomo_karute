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

ActiveRecord::Schema[7.2].define(version: 2025_12_13_122219) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "disease_records", force: :cascade do |t|
    t.bigint "kid_id", null: false
    t.datetime "start_at"
    t.datetime "end_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kid_id"], name: "index_disease_records_on_kid_id"
  end

  create_table "kids", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.date "birthday"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_kids_on_user_id"
  end

  create_table "reported_symptoms", force: :cascade do |t|
    t.bigint "disease_record_id", null: false
    t.bigint "symptom_name_id"
    t.datetime "recorded_at"
    t.text "memo"
    t.float "body_temperature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["disease_record_id"], name: "index_reported_symptoms_on_disease_record_id"
    t.index ["symptom_name_id"], name: "index_reported_symptoms_on_symptom_name_id"
  end

  create_table "symptom_names", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "disease_records", "kids"
  add_foreign_key "kids", "users"
  add_foreign_key "reported_symptoms", "disease_records"
  add_foreign_key "reported_symptoms", "symptom_names"
end
