# frozen_string_literal: true

module FranceConnectExtends
  extend ActiveSupport::Concern

  included do
    private

    def redirect_uri
      "#{omniauth_callback_url}?#{params.slice("redirect_uri", "after_action").to_query}"
    end
  end
end

OmniAuth::Strategies::FranceConnect.class_eval do
  include(FranceConnectExtends)
end
