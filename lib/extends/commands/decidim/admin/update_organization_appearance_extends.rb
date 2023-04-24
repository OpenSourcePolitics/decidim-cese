# frozen_string_literal: true

module UpdateOrganizationAppearanceExtends
  extend ActiveSupport::Concern

  included do
    private

    def image_fields
      [:logo, :highlighted_content_banner_image, :favicon, :official_img_header, :official_img_footer, :official_cachet, :official_signature]
    end
  end
end

Decidim::Admin::UpdateOrganizationAppearance.class_eval do
  include UpdateOrganizationAppearanceExtends
end
