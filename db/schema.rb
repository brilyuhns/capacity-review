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

ActiveRecord::Schema[8.0].define(version: 2025_05_03_024950) do
  create_table "capacities", force: :cascade do |t|
    t.date "period_start"
    t.string "period_type", default: "week"
    t.decimal "gross_capacity", null: false
    t.decimal "planned_leaves", default: "0.0", null: false
    t.decimal "unplanned_leaves", default: "0.0", null: false
    t.string "source", default: "imported", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["period_start", "period_type"], name: "index_capacities_on_period_start_and_period_type", unique: true
  end

  create_table "project_allocations", force: :cascade do |t|
    t.integer "project_id", null: false
    t.date "period_start", null: false
    t.string "period_type", default: "week", null: false
    t.decimal "allocation", null: false
    t.string "source", default: "manual", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id", "period_start", "period_type"], name: "index_project_allocations_on_project_period", unique: true
    t.index ["project_id"], name: "index_project_allocations_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.string "category", null: false
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "project_allocations", "projects"
end
