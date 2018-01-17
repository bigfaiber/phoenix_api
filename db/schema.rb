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

ActiveRecord::Schema.define(version: 20180111001745) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "bank", null: false
    t.bigint "account_type", default: 0, null: false
    t.integer "account_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admins", force: :cascade do |t|
    t.string "name", null: false
    t.string "lastname", null: false
    t.string "email", null: false
    t.text "password_digest", null: false
    t.text "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.string "lastname", null: false
    t.string "identification", null: false
    t.string "phone", null: false
    t.string "address", null: false
    t.date "birthday", null: false
    t.string "email", null: false
    t.string "city", null: false
    t.text "password_digest", null: false
    t.text "code", default: ""
    t.boolean "code_confirmation", default: false
    t.boolean "rent", default: false
    t.string "rent_payment", default: "0"
    t.integer "people", default: 0, null: false
    t.integer "education", default: 0, null: false
    t.integer "marital_status", default: 0, null: false
    t.boolean "rent_tax", default: false
    t.integer "employment_status", default: 0, null: false
    t.boolean "terms_and_conditions", default: false
    t.boolean "new_client", default: true
    t.float "rating", default: 0.0
    t.text "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "token"
    t.string "nivel"
    t.string "stability"
    t.string "job_position"
    t.string "patrimony"
    t.string "max_capacity"
    t.string "current_debt"
    t.string "income"
    t.string "payment_capacity"
  end

  create_table "documents", force: :cascade do |t|
    t.integer "document_type", default: 0, null: false
    t.text "document", null: false
    t.string "imageable_type"
    t.bigint "imageable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_type", "imageable_type", "imageable_id"], name: "document_index", unique: true
    t.index ["imageable_type", "imageable_id"], name: "index_documents_on_imageable_type_and_imageable_id"
  end

  create_table "estates", force: :cascade do |t|
    t.string "price", null: false
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_estates_on_client_id"
  end

  create_table "investors", force: :cascade do |t|
    t.string "name", null: false
    t.string "lastname", null: false
    t.string "identification", null: false
    t.string "phone", null: false
    t.string "address", null: false
    t.date "birthday", null: false
    t.string "email", null: false
    t.string "city", null: false
    t.string "password_digest", null: false
    t.text "code", default: "", null: false
    t.boolean "code_confirmation", default: false
    t.integer "employment_status", default: 0, null: false
    t.integer "education", default: 0, null: false
    t.boolean "rent_tax", default: false
    t.boolean "terms_and_conditions", default: false
    t.text "avatar"
    t.boolean "new_investor", default: true
    t.integer "money_invest", null: false
    t.integer "month", default: 1, null: false
    t.integer "monthly_payment", null: false
    t.integer "profitability", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "token"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "investor_id"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["investor_id"], name: "index_matches_on_investor_id"
    t.index ["project_id", "investor_id"], name: "index_matches_on_project_id_and_investor_id", unique: true
    t.index ["project_id"], name: "index_matches_on_project_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "payment_type", default: 0, null: false
    t.string "name", null: false
    t.string "lastname", null: false
    t.string "card_number", null: false
    t.integer "card_type", default: 0, null: false
    t.string "ccv", default: "", null: false
    t.string "month", null: false
    t.string "year", null: false
    t.bigint "investor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["investor_id"], name: "index_payments_on_investor_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "dream", null: false
    t.text "description", default: "", null: false
    t.integer "money", null: false
    t.integer "monthly_payment", null: false
    t.integer "month", null: false
    t.boolean "approved", default: false
    t.integer "warranty", default: 0, null: false
    t.float "interest_rate", default: 1.5, null: false
    t.bigint "investor_id"
    t.bigint "account_id"
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "initial_payment"
    t.boolean "new_project", default: true
    t.index ["account_id"], name: "index_projects_on_account_id"
    t.index ["client_id"], name: "index_projects_on_client_id"
    t.index ["investor_id"], name: "index_projects_on_investor_id"
  end

  create_table "receipts", force: :cascade do |t|
    t.integer "month", default: 1, null: false
    t.integer "year", null: false
    t.text "receipt"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "day"
    t.index ["project_id"], name: "index_receipts_on_project_id"
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "price", null: false
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_vehicles_on_client_id"
  end

  add_foreign_key "estates", "clients"
  add_foreign_key "matches", "investors"
  add_foreign_key "matches", "projects"
  add_foreign_key "projects", "clients"
  add_foreign_key "receipts", "projects"
  add_foreign_key "vehicles", "clients"
end
