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

ActiveRecord::Schema[7.1].define(version: 2024_02_17_220354) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bidders", force: :cascade do |t|
    t.bigint "telegram_id"
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.boolean "is_bot"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["telegram_id"], name: "index_bidders_on_telegram_id"
  end

  create_table "bids", force: :cascade do |t|
    t.bigint "bidder_id", null: false
    t.bigint "lot_id", null: false
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bidder_id"], name: "index_bids_on_bidder_id"
    t.index ["lot_id"], name: "index_bids_on_lot_id"
  end

  create_table "lots", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "start_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bids", "bidders"
  add_foreign_key "bids", "lots"
end
