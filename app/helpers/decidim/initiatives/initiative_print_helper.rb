# frozen_string_literal: true

module Decidim
  module Initiatives
    module InitiativePrintHelper
      include Decidim::TranslatableAttributes
      def i18n_options
        {
          name: author_name,
          title: translated_attribute(current_initiative.title),
          publication_date: current_initiative.published_at.to_date.strftime("%d/%m/%Y"),
          end_date: current_initiative.signature_end_date.strftime("%d/%m/%Y")
        }
      end

      def signature_image_tag
        return if ENV.fetch("IMG_SIGNATURE", nil).blank?
        return unless ENV.fetch("IMG_SIGNATURE", nil).to_s.include?("data:image/")

        image_tag ENV.fetch("IMG_SIGNATURE", nil).to_s, width: "250"
      end

      def cachet_image_tag
        return if ENV.fetch("IMG_CACHET", nil).blank?
        return unless ENV.fetch("IMG_CACHET", nil).to_s.include?("data:image/")

        image_tag ENV.fetch("IMG_CACHET", nil).to_s, width: "200"
      end

      private

      def author_name
        authorization = Decidim::Authorization.where(user: current_initiative.author, name: "extended_socio_demographic_authorization_handler").first

        return current_initiative.author.name unless authorization

        "#{authorization.metadata["first_name"]} #{authorization.metadata["last_name"]}"
      end
    end
  end
end
