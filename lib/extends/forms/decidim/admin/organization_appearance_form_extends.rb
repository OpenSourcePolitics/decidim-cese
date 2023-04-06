# frozen_string_literal: true

module OrganizationAppearanceFormExtends
  extend ActiveSupport::Concern

  included do
    attribute :official_signature
    attribute :remove_official_signature, :boolean, default: false

    attribute :official_cachet
    attribute :remove_official_cachet, :boolean, default: false

    validates :official_signature,
              :official_cachet,
              passthru: { to: Decidim::Organization }
  end
end

Decidim::Admin::OrganizationAppearanceForm.class_eval do
  include OrganizationAppearanceFormExtends
end
