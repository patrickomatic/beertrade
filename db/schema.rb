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

ActiveRecord::Schema.define(version: 20151027171552) do

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "trade_id",   null: false
    t.text     "message",    null: false
    t.datetime "seen_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "hashcode",   null: false
  end

  create_table "participants", force: :cascade do |t|
    t.integer  "user_id",              null: false
    t.integer  "trade_id",             null: false
    t.text     "shipping_info"
    t.text     "feedback"
    t.integer  "feedback_type"
    t.datetime "accepted_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "feedback_approved_at"
  end

  add_index "participants", ["trade_id"], name: "index_participants_on_trade_id"
  add_index "participants", ["user_id"], name: "index_participants_on_user_id"

  create_table "trades", force: :cascade do |t|
    t.text     "agreement"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.datetime "completed_at"
  end

  create_table "users", force: :cascade do |t|
    t.text     "username",                   null: false
    t.string   "auth_uid"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "moderator",  default: false
  end

  add_index "users", ["auth_uid"], name: "index_users_on_auth_uid"
  add_index "users", ["username"], name: "index_users_on_lower_username", unique: true

end
