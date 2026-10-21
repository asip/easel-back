# frozen_string_literal: true

Rails.application.config.to_prepare do
  ActiveModel::Type.register(:array, Vesper::Model::Types::ArrayType)
  ActiveModel::Type.register(:hash, Vesper::Model::Types::HashType)
end
