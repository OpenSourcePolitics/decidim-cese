# frozen_string_literal: true

module HomepageControllerExtends
  extend ActiveSupport::Concern

  included do
    before_action :france_connect_after_sign_out, only: [:show]

    def france_connect_after_sign_out
      if session["omniauth.france_connect.post_logout_redirect_uri"].present?
        post_logout_redirect_uri = session["omniauth.france_connect.post_logout_redirect_uri"]
        session.delete("omniauth.france_connect.post_logout_redirect_uri")
        redirect_to post_logout_redirect_uri
      end
    end
  end
end

Decidim::HomepageController.class_eval do
  include(HomepageControllerExtends)
end
