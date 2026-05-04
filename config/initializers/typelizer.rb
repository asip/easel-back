# frozen_string_literal: true

# Directories to search for serializers
Typelizer.dirs = [ Rails.root.join("app", "resources") ]

Typelizer.configure do |config|
  # Strategy for handling serializer inheritance (:none, :inheritance)
  # :none - lists all attributes of the serializer in the type
  # :inheritance - extends the type from the parent serializer
  config.inheritance_strategy = :inheritance

  # Strategy for handling has_one and belongs_to associations nullability
  # :database - uses the database column nullability
  # :active_record - uses the required / optional association options
  # config.associations_strategy = :active_record

  # Import path for generated types in TypeScript files
  # config.types_import_path = "@/types"
  config.types_import_path = "./"

  # Directory where TypeScript interfaces will be generated
  config.output_dir = Rails.root.join("doc/types/serializers")
end
