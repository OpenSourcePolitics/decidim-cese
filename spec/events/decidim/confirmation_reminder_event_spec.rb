# frozen_string_literal: true

require "spec_helper"

describe Decidim::ConfirmationReminderEvent do
  include_context "when a simple event"

  let(:event_name) { "decidim.events.confirmation_reminder_event" }
  let(:resource) { create :user }

  describe "notification_title" do
    it "is generated correctly" do
      expect(subject.notification_title).to include("You created an account there is 2 days ago and you haven't confirmed your email yet. Please confirm your email address to persist your votes.")
    end
  end
end
