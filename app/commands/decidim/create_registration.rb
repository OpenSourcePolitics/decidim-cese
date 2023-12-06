# frozen_string_literal: true

module Decidim
  # A command with all the business logic to create a user through the sign up form.
  class CreateRegistration < Decidim::Command
    # Public: Initializes the command.
    #
    # form - A form object with the params.
    def initialize(form)
      @form = form
    end

    # Executes the command. Broadcasts these events:
    #
    # - :ok when everything is valid.
    # - :invalid if the form wasn't valid and we couldn't proceed.
    #
    # Returns nothing.
    def call
      if form.invalid?
        user = User.has_pending_invitations?(form.current_organization.id, form.email)
        user.invite!(user.invited_by) if user
        return broadcast(:invalid)
      end

      create_user

      broadcast(:ok, @user)
    rescue ActiveRecord::RecordInvalid
      broadcast(:invalid)
    end

    private

    attr_reader :form

    def create_user
      @user = User.create!(
        email: form.email,
        name: form.name,
        nickname: form.nickname,
        password: form.password,
        password_confirmation: form.password_confirmation,
        password_updated_at: Time.current,
        organization: form.current_organization,
        tos_agreement: form.tos_agreement,
        newsletter_notifications_at: nil,
        accepted_tos_version: form.current_organization.tos_version,
        locale: form.current_locale,
        notifications_sending_frequency: :none,
        extended_data: extended_data
      )
    end

    def extended_data
      {
        birth_date: form.birth_date,
        address: form.address,
        postal_code: form.postal_code,
        city: form.city,
        certification: form.certification
      }
    end
  end
end
