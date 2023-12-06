# frozen_string_literal: true

require "active_support/concern"

module OmniauthRegistrationFormExtend
  extend ActiveSupport::Concern

  included do
    attribute :birth_date, Date
    attribute :address, String
    attribute :postal_code, String
    attribute :city, String

    validates :email, 'valid_email_2/email': { mx: true }
    validates :postal_code,
              :birth_date,
              :city,
              :address,
              presence: true

    validate :over_16?

    private

    def over_16?
      return if birth_date.blank?
      return if 16.years.ago.to_date > birth_date

      errors.add :base, I18n.t("decidim.devise.registrations.form.errors.messages.over_16")
    end
  end
end

Decidim::OmniauthRegistrationForm.class_eval do
  clear_validators!
  include OmniauthRegistrationFormExtend
end