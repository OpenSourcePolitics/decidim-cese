# frozen_string_literal: true

module Decidim
  class ConfirmationReminderJob < ApplicationJob
    def perform
      unconfirmed_users.each do |user|
        puts unconfirmed_users.map(&:email)
        send_notification(user)
      end
    end

    private

    def unconfirmed_users
      @unconfirmed_users ||= Decidim::User.not_confirmed.where("DATE(created_at) = ?", 2.days.ago)
    end

    def send_notification(user)
      Decidim::EventsManager.publish(
        event: "decidim.events.confirmation_reminder_event",
        event_class: ConfirmationReminderEvent,
        resource: nil,
        affected_users: [user],
        force_send: true,
        extra: {}
      )
    end
  end
end

