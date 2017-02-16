# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and tputs Company.where("clanovi LIKE ?", "%greska1%").counthe greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161222080718) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.integer  "MB"
    t.string   "poslovno_ime"
    t.string   "status"
    t.string   "pravna_forma"
    t.string   "opstina"
    t.string   "mesto"
    t.string   "ulica_i_broj"
    t.string   "datum_osnivanja"
    t.integer  "PIB"
    t.integer  "sifra_delatnosti"
    t.string   "naziv_delatnosti"
    t.text     "zastupnici"
    t.text     "ostali_zastupnici"
    t.text     "nadzorni_odbor"
    t.text     "upravni_odbor"
    t.text     "clanovi"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "oblast"
  end

  add_index "companies", ["MB"], name: "index_companies_on_MB", unique: true, using: :btree

  create_table "company_types", force: :cascade do |t|
    t.integer  "idnumber"
    t.string   "name"
    t.string   "skraceno"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number"
  end

  add_index "company_types", ["skraceno"], name: "index_company_types_on_skraceno", unique: true, using: :btree

  create_table "oblasts", force: :cascade do |t|
    t.string   "name"
    t.integer  "broj"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "ime_i_prezime"
    t.string   "jmbg"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "broj_pojavljivanja_kao_clan"
    t.integer  "broj_pojavljivanja_kao_zastupnik"
    t.integer  "broj_pojavljivanja_kao_ostali_zastupnik"
    t.integer  "broj_pojavljivanja_kao_upravni"
    t.integer  "broj_pojavljivanja_kao_nadzorni"
    t.integer  "ukupno"
  end

  create_table "sectors", force: :cascade do |t|
    t.string   "idnumber"
    t.string   "naziv"
    t.string   "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "sum"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.integer  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
