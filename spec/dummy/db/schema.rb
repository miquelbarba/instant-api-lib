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

ActiveRecord::Schema.define(version: 20131020164349) do

  create_table "addresses", force: true do |t|
    t.string   "street"
    t.string   "number"
    t.string   "postal_code"
    t.string   "city"
    t.string   "country"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "as", force: true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "as_ds", force: true do |t|
    t.integer "a_id"
    t.integer "d_id"
  end

  create_table "bs", force: true do |t|
    t.string   "value"
    t.integer  "a_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cs", force: true do |t|
    t.string   "value"
    t.integer  "b_id"
    t.integer  "a_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ds", force: true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.integer  "age"
    t.date     "born_at"
    t.datetime "registered_at"
    t.boolean  "terms_accepted"
    t.decimal  "money",          precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
