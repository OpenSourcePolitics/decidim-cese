# frozen_string_literal: true

module Decidim
  # A form object used to handle user registrations
  class RegistrationForm < Form
    mimic :user

    attribute :name, String
    attribute :nickname, String
    attribute :email, String
    attribute :password, String
    attribute :password_confirmation, String
    attribute :newsletter, Boolean
    attribute :tos_agreement, Boolean
    attribute :current_locale, String

    # Extended socio demographic attributes
    attribute :birth_date, Date
    attribute :address, String
    attribute :postal_code, String
    attribute :city, String
    attribute :certification, Boolean
    attribute :news_cese, Boolean

    validates :name, presence: true, format: { with: Decidim::User::REGEXP_NAME }
    validates :nickname, presence: true, format: { with: Decidim::User::REGEXP_NICKNAME }, length: { maximum: Decidim::User.nickname_max_length }
    validates :email, presence: true, "valid_email_2/email": { disposable: true }
    validates :password, confirmation: true
    validates :password, password: { name: :name, email: :email, username: :nickname }
    validates :password_confirmation, presence: true
    validates :tos_agreement, allow_nil: false, acceptance: true

    # Extended socio demographic validations
    validates :birth_date, presence: true
    validates :address, presence: true
    validates :postal_code, numericality: { only_integer: true }, presence: true, length: { is: 5 }
    validates :city, presence: true
    validates :certification, acceptance: true, presence: true
    validate :over_16?

    validate :email_unique_in_organization
    validate :nickname_unique_in_organization
    validate :no_pending_invitations_exist

    def newsletter_at
      return nil unless newsletter?

      Time.current
    end

    private

    def email_unique_in_organization
      errors.add :email, :taken if valid_users.find_by(email: email, organization: current_organization).present?
    end

    def nickname_unique_in_organization
      return false unless nickname

      errors.add :nickname, :taken if valid_users.find_by("LOWER(nickname)= ? AND decidim_organization_id = ?", nickname.downcase, current_organization.id).present?
    end

    def valid_users
      UserBaseEntity.where(invitation_token: nil)
    end

    def no_pending_invitations_exist
      errors.add :base, I18n.t("devise.failure.invited") if User.has_pending_invitations?(current_organization.id, email)
    end

    def over_16?
      return if birth_date.blank?
      return if 16.years.ago.to_date > birth_date

      errors.add :birth_date, I18n.t("decidim.devise.registrations.form.errors.messages.over_16")
    end
  end
end
