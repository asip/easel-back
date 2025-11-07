class DropActsAsTaggableOn < ActiveRecord::Migration[8.1]
  def up
    drop_table :taggings
    drop_table :tags
  end

  def down
    create_table "taggings", force: :cascade do |t|
      t.string "context", limit: 128
      t.datetime "created_at", precision: nil
      t.bigint "tag_id"
      t.bigint "taggable_id"
      t.string "taggable_type"
      t.bigint "tagger_id"
      t.string "tagger_type"
      t.datetime "updated_at", precision: nil
      t.index [ "context" ], name: "index_taggings_on_context"
      t.index [ "tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type" ], name: "taggings_idx", unique: true
      t.index [ "tag_id" ], name: "index_taggings_on_tag_id"
      t.index [ "taggable_id", "taggable_type", "context" ], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
      t.index [ "taggable_id", "taggable_type", "tagger_id", "context" ], name: "taggings_idy"
      t.index [ "taggable_id" ], name: "index_taggings_on_taggable_id"
      t.index [ "taggable_type" ], name: "index_taggings_on_taggable_type"
      t.index [ "tagger_id", "tagger_type" ], name: "index_taggings_on_tagger_id_and_tagger_type"
      t.index [ "tagger_id" ], name: "index_taggings_on_tagger_id"
    end

    create_table "tags", force: :cascade do |t|
      t.datetime "created_at", precision: nil
      t.string "name"
      t.integer "taggings_count", default: 0
      t.datetime "updated_at", precision: nil
      t.index [ "name" ], name: "index_tags_on_name", unique: true
    end
  end
end
