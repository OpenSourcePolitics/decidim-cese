# frozen_string_literal: true

require "notifications_digest"

class SendNotificationMailDailyJob < ApplicationJob
  queue_as :mailers

  def perform
    NotificationsDigest.notifications_digest(:daily)
  end
end
