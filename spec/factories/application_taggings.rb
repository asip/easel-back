FactoryBot.define do
  factory :application_tagging do
    taggable_type { 'Frame' }
    context { 'tag' }
  end
end
