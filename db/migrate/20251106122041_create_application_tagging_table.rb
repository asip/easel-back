class CreateApplicationTaggingTable < ActiveRecord::Migration[8.1]
  def up
    create_table :application_tags do |t|
      t.string :name, null: false, index: { unique: true }
      t.timestamp :created_at, default: -> { 'CURRENT_TIMESTAMP' }, null: false
      t.timestamp :updated_at, default: -> { 'CURRENT_TIMESTAMP' }, null: false
    end

    create_table :application_taggings do |t|
      t.references :tag, null: false, foreign_key: { to_table: :application_tags }
      t.references :taggable, polymorphic: true, null: false
      t.string :context, null: false
      t.timestamp :created_at, default: -> { 'CURRENT_TIMESTAMP' }, null: false
      t.timestamp :updated_at, default: -> { 'CURRENT_TIMESTAMP' }, null: false

      # Add index for uniqueness and performance
      t.index [ :taggable_type, :taggable_id, :context, :tag_id ],
              unique: true,
              name: 'index_app_taggings_uniqueness'

      # Add index for faster lookups by context
      t.index [ :context ]
    end
  end
end
