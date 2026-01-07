# frozen_string_literal: true

# contents
module Contents
  # Uploader class
  class Uploader < Shrine
    Attacher.validate do
      validate_max_size 5 * 1024 * 1024, message: I18n.t("validations.message.frame.file.max_size")
      # validate_min_size 1, message: I18n.t('validations.message.frame.file.required')
      validate_mime_type %w[image/jpg image/jpeg image/png image/webp image/avif],
                         message: I18n.t("validations.message.frame.file.mime_type")
    end

    # Attacher.derivatives do |original|
    #   pipeline = ImageProcessing::Vips.source(original)
    #
    #   {
    #     two: pipeline.resize_to_limit!(200, 200),
    #     three: pipeline.resize_to_limit!(300, 300)
    #   }
    # end
  end
end
