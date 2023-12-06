# frozen_string_literal: true

module InitiativesControllerExtends
  extend ActiveSupport::Concern

  included do
    include Decidim::AfterSignInActionHelper

    helper Decidim::Initiatives::SignatureTypeOptionsHelper
    helper Decidim::Initiatives::InitiativePrintHelper

    helper_method :available_initiative_types

    def show
      enforce_permission_to :read, :initiative, initiative: current_initiative
      if session["tos_after_action"].present? && URI.parse(request.referer).path == tos_path.split("?")&.first
        tos_after_action = session["tos_after_action"]
        session.delete("tos_after_action")
        after_sign_in_action_for(current_user, tos_after_action)
      end
    end

    def print
      enforce_permission_to :print, :initiative, initiative: current_initiative
    end

    private

    def default_filter_params
      {
        search_text_cont: "",
        with_any_state: %w(open),
        with_any_type: default_filter_type_params,
        author: "any",
        with_any_scope: default_filter_scope_params,
        with_any_area: default_filter_area_params,
        with_any_status: default_filter_status_params
      }
    end

    def default_filter_status_params
      %w(all) + current_organization.statuses.pluck(:id).map(&:to_s)
    end
  end
end

Decidim::Initiatives::InitiativesController.class_eval do
  include(InitiativesControllerExtends)
end
