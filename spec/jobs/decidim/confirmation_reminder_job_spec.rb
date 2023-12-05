# frozen_string_literal: true

require "spec_helper"

describe Decidim::ConfirmationReminderJob do
  subject { described_class }

  let!(:unconfirmed_users) { create_list(:user, 2, created_at: 2.days.ago) }

  before do
    create(:user, created_at: 3.days.ago)
    create(:user, :confirmed, created_at: 2.days.ago)
    create(:user, created_at: 1.day.ago)
  end

  it "sends a reminder to unconfirmed users" do
    expect { subject.new.perform }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end

  describe "#unconfirmed_users" do
    it "returns the unconfirmed users" do
      expect(subject.new.send(:unconfirmed_users)).to match_array(unconfirmed_users)
    end
  end
end
