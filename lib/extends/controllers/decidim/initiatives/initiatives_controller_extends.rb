# frozen_string_literal: true

module InitiativesControllerExtends
  extend ActiveSupport::Concern

  included do
    helper Decidim::Initiatives::CreateInitiativeHelper

    helper_method :available_initiative_types
  end
end

Decidim::Initiatives::InitiativesController.class_eval do
  include(InitiativesControllerExtends)
end
