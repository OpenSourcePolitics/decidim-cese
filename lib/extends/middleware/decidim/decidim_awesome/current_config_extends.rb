# frozen_string_literal: true

module Decidim
  module DecidimAwesome
    module CurrentConfigExtends
      private

      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      def additional_post_constraints(constraints)
        return [] unless @request.post? || @request.patch?

        constraints.filter_map do |constraint|
          settings = constraint.settings.dup
          next unless settings["participatory_space_manifest"].present? && settings["participatory_space_slug"].present?

          # replicate the constraint with the id of the participatory space
          manifest = Decidim.participatory_space_manifests.find { |s| s.name.to_s == settings["participatory_space_manifest"] }
          next unless manifest

          model = manifest.model_class_name.try(:constantize)
          next unless model

          settings["participatory_space_slug"] =
            model == Decidim::Initiative ? settings["participatory_space_slug"].split("-").last : model.find_by(slug: settings["participatory_space_slug"])&.id
          OpenStruct.new(settings: settings) if settings["participatory_space_slug"]
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity
    end
  end
end

Decidim::DecidimAwesome::CurrentConfig.class_eval do
  prepend(Decidim::DecidimAwesome::CurrentConfigExtends)
end
