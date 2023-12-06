# frozen_string_literal: true

module Decidim
  class UnconfirmedVotesClearMailer < ApplicationMailer
    helper Decidim::SanitizeHelper
    helper Decidim::TranslationsHelper

    def send_resume(user, initiatives)
      return if user&.email.blank?

      @organization = user.organization
      @user = user
      @initiatives = initiatives

      with_user(user) do
        @subject = I18n.t(".subject", scope: "decidim.unconfirmed_votes_clear_mailer.send_resume")

        mail(to: "#{user.name} <#{user.email}>", subject: @subject)
      end
    end
  end
end
