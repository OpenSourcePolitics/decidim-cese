# frozen_string_literal: true

module FranceConnectExtends
  extend ActiveSupport::Concern

  included do
    private

    def redirect_uri
      uri = URI.parse(super)
      uri.query = [uri.query, "after_action=#{params["after_action"]}"].compact.join("&") if params["after_action"].present?
      uri.to_s
    end
  end
end

OmniAuth::Strategies::FranceConnect.class_eval do
  include(FranceConnectExtends)
end
