# frozen_string_literal: true

module InitiativesControllerExtends
  extend ActiveSupport::Concern

  included do
    helper Decidim::Initiatives::CreateInitiativeHelper
    helper Decidim::Initiatives::InitiativePrintHelper

    helper_method :available_initiative_types

    def print
      enforce_permission_to :print, :initiative, initiative: current_initiative
    end
  end
end

Decidim::Initiatives::InitiativesController.class_eval do
  include(InitiativesControllerExtends)
end
