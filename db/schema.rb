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

ActiveRecord::Schema.define(version: 20150712212953) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.string   "deck_state", default: "dddddddddddddddddddddddddddddddddddddddddddddddddddd"
    t.integer  "pot"
    t.integer  "bet"
    t.boolean  "live",       default: true
    t.datetime "created_at",                                                                  null: false
    t.datetime "updated_at",                                                                  null: false
    t.string   "token"
    t.integer  "size",       default: 2
    t.integer  "street"
    t.integer  "button",     default: 0
  end

  create_table "hands", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "game_id"
    t.integer  "stack",      default: 0
    t.integer  "bet",        default: 0
    t.integer  "number",                     null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "ai",         default: false
  end

  add_index "hands", ["game_id"], name: "index_hands_on_game_id", using: :btree
  add_index "hands", ["player_id"], name: "index_hands_on_player_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.integer  "bankroll",   default: 2000, null: false
    t.boolean  "horse",      default: true
    t.string   "token",                     null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_foreign_key "hands", "games"
  add_foreign_key "hands", "players"
end
