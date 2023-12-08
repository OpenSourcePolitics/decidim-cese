# frozen_string_literal: true

module Decidim
  class ConfirmationReminderMailer < ApplicationMailer
    helper Decidim::SanitizeHelper
    helper Decidim::TranslationsHelper

    def send_reminder(user)
      return if user&.email.blank?

      @organization = user.organization
      @user = user
      root_url = decidim.root_url(host: @organization.host)[0..-2]
      @confirmation_link = "#{root_url}#{decidim.user_confirmation_path(confirmation_token: user.confirmation_token)}"
      with_user(user) do
        @subject = I18n.t("subject", scope: "decidim.confirmation_reminder_mailer.send_reminder")

        mail(to: "#{user.name} <#{user.email}>", subject: @subject)
      end
    end
  end
end
