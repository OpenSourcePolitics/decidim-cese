# frozen_string_literal: true

module Decidim
  module DecidimAwesome
    module Admin
      module ConfigConstraintsHelpersExtends
        def components_list(manifest, slug)
          space = model_for_manifest(manifest)
          return {} unless space&.column_names&.include?("slug") || space == Decidim::Initiative

          components = if space == Decidim::Initiative
                         Component.where(participatory_space: space.find_by(id: slug.split("-").last))
                       else
                         Component.where(participatory_space: space.find_by(slug: slug))
                       end

          components.to_h do |item|
            [item.id, "#{item.id}: #{translated_attribute(item.name)}"]
          end
        end
      end
    end
  end
end

Decidim::DecidimAwesome::Admin::ConfigConstraintsHelpers.module_eval do
  prepend(Decidim::DecidimAwesome::Admin::ConfigConstraintsHelpersExtends)
end
