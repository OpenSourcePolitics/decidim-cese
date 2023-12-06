# frozen_string_literal: true

require "active_support/concern"

module OmniauthRegistrationFormExtend
  extend ActiveSupport::Concern

  included do
    attribute :certification, ::ActiveModel::Type::Boolean
    attribute :birth_date, Date
    attribute :address, String
    attribute :postal_code, String
    attribute :city, String

    validates :email, "valid_email_2/email": { mx: true }
    validates :postal_code,
              :birth_date,
              :city,
              :address,
              :certification,
              presence: true

    validates :postal_code, numericality: { only_integer: true }, length: { is: 5 }
    validates :certification, acceptance: true
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
