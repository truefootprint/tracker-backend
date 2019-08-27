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

ActiveRecord::Schema.define(version: 2019_08_27_110444) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.bigint "question_id"
    t.bigint "company_id"
    t.integer "year"
    t.float "value"
    t.bigint "unit_id"
    t.bigint "auditor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auditor_id"], name: "index_answers_on_auditor_id"
    t.index ["company_id"], name: "index_answers_on_company_id"
    t.index ["question_id", "company_id", "year"], name: "index_answers_on_question_id_and_company_id_and_year", unique: true
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["unit_id"], name: "index_answers_on_unit_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.bigint "sector_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "logo"
    t.index ["name"], name: "index_companies_on_name", unique: true
    t.index ["sector_id"], name: "index_companies_on_sector_id"
  end

  create_table "group_members", force: :cascade do |t|
    t.bigint "group_id"
    t.string "member_type"
    t.bigint "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "member_type", "member_id"], name: "index_group_members_on_group_id_and_member_type_and_member_id", unique: true
    t.index ["group_id"], name: "index_group_members_on_group_id"
    t.index ["member_type", "member_id"], name: "index_group_members_on_member_type_and_member_id"
  end

  create_table "group_weights", force: :cascade do |t|
    t.string "name"
    t.bigint "group_id"
    t.float "weight"
    t.index ["group_id"], name: "index_group_weights_on_group_id"
    t.index ["name"], name: "index_group_weights_on_name"
  end

  create_table "groups", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_groups_on_name", unique: true
  end

  create_table "identifiers", force: :cascade do |t|
    t.string "target_type"
    t.bigint "target_id"
    t.string "name"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["target_type", "target_id", "name"], name: "index_identifiers_on_target_type_and_target_id_and_name", unique: true
    t.index ["target_type", "target_id"], name: "index_identifiers_on_target_type_and_target_id"
  end

  create_table "mappings", force: :cascade do |t|
    t.bigint "outcome_id"
    t.bigint "question_id"
    t.bigint "divisor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["divisor_id"], name: "index_mappings_on_divisor_id"
    t.index ["outcome_id"], name: "index_mappings_on_outcome_id", unique: true
    t.index ["question_id"], name: "index_mappings_on_question_id"
  end

  create_table "outcomes", force: :cascade do |t|
    t.text "name"
    t.boolean "higher_is_better", null: false
    t.bigint "unit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "auditor_id"
    t.index ["auditor_id"], name: "index_outcomes_on_auditor_id"
    t.index ["name"], name: "index_outcomes_on_name", unique: true
    t.index ["unit_id"], name: "index_outcomes_on_unit_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "text"
    t.bigint "unit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["text"], name: "index_questions_on_text", unique: true
    t.index ["unit_id"], name: "index_questions_on_unit_id"
  end

  create_table "sectors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sectors_on_name", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.string "target_type"
    t.bigint "target_id"
    t.string "name"
    t.index ["name"], name: "index_tags_on_name"
    t.index ["target_id", "name"], name: "index_tags_on_target_id_and_name", unique: true
    t.index ["target_type", "target_id"], name: "index_tags_on_target_type_and_target_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_units_on_name", unique: true
  end

end
