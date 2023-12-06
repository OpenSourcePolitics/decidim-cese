# frozen_string_literal: true

module Decidim
  class ConfirmationReminderJob < ApplicationJob
    def perform
      unconfirmed_users.each do |user|
        Decidim::ConfirmationReminderMailer.send_reminder(user).deliver_now
      end
    end

    private

    def unconfirmed_users
      @unconfirmed_users ||= Decidim::User.not_confirmed.where("DATE(created_at) = ?", Rails.application.secrets.dig(:decidim, :reminder, :unconfirmed_email, :days).days.ago)
    end
  end
end
