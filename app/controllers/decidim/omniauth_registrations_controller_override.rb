# frozen_string_literal: true

module Decidim
  module OmniauthRegistrationsControllerOverride
    extend ActiveSupport::Concern

    included do
      include Decidim::AfterSignInActionHelper

      def after_sign_in_path_for(user)
        after_sign_in_action_for(user, request.params[:after_action]) if request.params[:after_action].present?

        if user.present? && user.blocked?
          check_user_block_status(user)
        elsif user.present? && !user.tos_accepted? && request.params[:after_action].present?
          session["tos_after_action"] = request.params[:after_action]
          super
        elsif !pending_redirect?(user) && first_login_and_not_authorized?(user)
          decidim_verifications.authorizations_path
        else
          super
        end
      end

      private

      def verified_email
        @verified_email ||= find_verified_email
      end

      def find_verified_email
        if oauth_data.present?
          session["oauth_data.verified_email"] = oauth_data.dig(:info, :email)
        else
          email_from_session = session["oauth_data.verified_email"]
          session.delete("oauth_data.verified_email")
          email_from_session
        end
      end
    end
  end
end
