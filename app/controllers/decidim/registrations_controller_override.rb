# frozen_string_literal: true

module Decidim
  module RegistrationsControllerOverride
    extend ActiveSupport::Concern

    included do
      include Decidim::AfterSignInActionHelper

      def after_sign_in_path_for(user)
        after_sign_in_action_for(user, request.params[:after_action]) if request.params[:after_action].present?
        super
      end
    end
  end
end
