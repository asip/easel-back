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

ActiveRecord::Schema[8.1].define(version: 2025_11_19_124951) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "application_taggings", force: :cascade do |t|
    t.string "context", null: false
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "tag_id", null: false
    t.bigint "taggable_id", null: false
    t.string "taggable_type", null: false
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["context"], name: "index_application_taggings_on_context"
    t.index ["tag_id"], name: "index_application_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id", "context", "tag_id"], name: "index_app_taggings_uniqueness", unique: true
    t.index ["taggable_type", "taggable_id"], name: "index_application_taggings_on_taggable"
  end

  create_table "application_tags", force: :cascade do |t|
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "name", null: false
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["name"], name: "index_application_tags_on_name", unique: true
  end

  create_table "authentications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "frame_id", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id", null: false
  end

  create_table "follow_relationships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "followee_id"
    t.bigint "follower_id"
    t.datetime "updated_at", null: false
  end

  create_table "frames", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", precision: nil, null: false
    t.string "creator_name"
    t.text "file_data"
    t.string "joined_tags"
    t.string "name", null: false
    t.boolean "private", default: false
    t.datetime "shooted_at"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at"
    t.string "email", null: false
    t.string "encrypted_password", default: "", null: false
    t.text "image_data"
    t.string "name", null: false
    t.text "profile"
    t.string "time_zone"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "application_taggings", "application_tags", column: "tag_id"
end
