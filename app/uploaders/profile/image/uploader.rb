# frozen_string_literal: true

# Profile::Image::Uploader class
class Profile::Image::Uploader < Shrine
  Attacher.validate do
    validate_max_size 5 * 1024 * 1024, message: I18n.t("validations.message.user.image.max_size")
    # validate_min_size 1, message: I18n.t('validations.message.user.image.required')
    validate_mime_type %w[image/jpg image/jpeg image/png image/webp image/avif],
                       message: I18n.t("validations.message.user.image.mime_type")
  end

  # Attacher.derivatives do |original|
  #   pipeline = ImageProcessing::Vips.source(original)
  #
  #   {
  #     thumb: pipeline.resize_to_limit!(50, 50),
  #     one: pipeline.resize_to_limit!(100, 100),
  #     three: pipeline.resize_to_limit!(300, 300)
  #   }
  # end
end
