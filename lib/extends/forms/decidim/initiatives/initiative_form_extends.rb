# frozen_string_literal: true

module Decidim
  module Initiatives
    module InitiativeFormExtends
      def map_model(model)
        self.title = translated_attribute(model.title)
        self.description = translated_attribute(model.description)
        self.type_id = model.type.id
        self.scope_id = model.scope&.id
      end
    end
  end
end

Decidim::Initiatives::InitiativeForm.class_eval do
  prepend Decidim::Initiatives::InitiativeFormExtends
end
