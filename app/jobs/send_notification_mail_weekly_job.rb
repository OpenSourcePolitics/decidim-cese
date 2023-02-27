# frozen_string_literal: true

require "notifications_digest"

class SendNotificationMailWeeklyJob < ApplicationJob
  queue_as :mailers

  def perform
    NotificationsDigest.notifications_digest(:weekly)
  end
end
