# frozen_string_literal: true

namespace :easel do
  desc "From AATO to NFL"
  task from_aato_to_nfl: :environment do
    tag_id_map = {}
    ActsAsTaggableOn::Tag.all.each { |tag|
      application_tag = ApplicationTag.new
      application_tag.name = tag.name
      application_tag.save
      tag_id_map[tag.id] = application_tag.id
    }

    ActsAsTaggableOn::Tagging.all.each { |tagging|
      application_tagging = ApplicationTagging.new
      application_tagging.tag_id = tag_id_map[tagging.tag_id]
      application_tagging.taggable_type = tagging.taggable_type
      application_tagging.taggable_id = tagging.taggable_id
      application_tagging.context = tagging.context.singularize
      application_tagging.save
    }
  end
end
