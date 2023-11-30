# frozen_string_literal: true

module ConfirmationsControllerExtends
  extend ActiveSupport::Concern

  included do
    # Overwrites the default method to handle user groups confirmations.
    def after_confirmation_path_for(resource_name, resource)
      return ENV.fetch("AH_REDIRECT_AFTER_CONFIRMATION") if ENV.fetch("AH_REDIRECT_AFTER_CONFIRMATION", "false") != "false"
      return profile_path(resource.nickname) if resource_name == :user_group

      super
    end
  end
end

Decidim::Devise::ConfirmationsController.class_eval do
  include ConfirmationsControllerExtends
end
