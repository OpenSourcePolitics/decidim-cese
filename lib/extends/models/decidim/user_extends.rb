# frozen_string_literal: true

module UserExtends
  extend ActiveSupport::Concern

  included do
    # Whether this user can be verified against some authorization or not.
    def verifiable?
      Decidim.config.unconfirmed_access_for.positive? || confirmed? || managed? || being_impersonated?
    end
  end
end

Decidim::User.class_eval do
  include(UserExtends)
end
