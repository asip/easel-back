# frozen_string_literal: true

# Frame Search Form class
class FrameSearchForm
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :word, :string
  attribute :frame_name, :string
  attribute :tag_name, :string
  attribute :user_name, :string
  attribute :creator_name, :string
  attribute :date, :date
  attribute :date_before_type_cast, :string

  validates :word, length: { maximum: 40 }
  validates :frame_name, length: { maximum: 30 }
  validates :tag_name, length: { maximum: 10 }
  validates :user_name, length: { maximum: 40 }
  validates :creator_name, length: { maximum: 40 }
  validates :date_before_type_cast, date: true

  def initialize(attributes)
    attributes[:date_before_type_cast] = attributes[:date]
    super(attributes)
  end

  def to_h
    attributes.with_indifferent_access
  end
end
