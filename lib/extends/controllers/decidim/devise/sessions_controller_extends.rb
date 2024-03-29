# frozen_string_literal: true

module SessionControllerExtends
  extend ActiveSupport::Concern

  included do
    include Decidim::AfterSignInActionHelper

    def destroy
      after_sign_out_url = after_sign_out_path_for(current_user)
      current_user.invalidate_all_sessions!
      if active_france_connect_session?
        destroy_france_connect_session(session["omniauth.france_connect.end_session_uri"], after_sign_out_url)
      elsif params[:translation_suffix].present?
        super { set_flash_message! :notice, params[:translation_suffix], { scope: "decidim.devise.sessions" } }
      else
        super
      end
    end

    def after_sign_in_path_for(user)
      after_sign_in_action_for(user, request.params[:after_action]) if request.params[:after_action].present?

      if user.present? && user.blocked?
        check_user_block_status(user)
      elsif !skip_first_login_authorization? && (first_login_and_not_authorized?(user) && !user.admin? && !pending_redirect?(user))
        decidim_verifications.first_login_authorizations_path
      else
        super
      end
    end

    private

    # Skip authorization handler by default
    def skip_first_login_authorization?
      ActiveRecord::Type::Boolean.new.cast(ENV.fetch("SKIP_FIRST_LOGIN_AUTHORIZATION", "false"))
    end
  end

  def destroy_france_connect_session(fc_logout_path, post_logout_redirect_uri)
    signed_out = (::Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    if signed_out
      set_flash_message! :notice, :signed_out
      session.delete("omniauth.france_connect.end_session_uri")
    end
    session["omniauth.france_connect.post_logout_redirect_uri"] = post_logout_redirect_uri
    redirect_to fc_logout_path
  end

  def active_france_connect_session?
    current_organization.enabled_omniauth_providers.include?(:france_connect) && session["omniauth.france_connect.end_session_uri"].present?
  end
end

Decidim::Devise::SessionsController.class_eval do
  include(SessionControllerExtends)
end
