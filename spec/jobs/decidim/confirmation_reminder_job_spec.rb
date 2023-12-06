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

  context "when confirmation reminder is set to 3 days" do
    before do
      allow(Rails.application.secrets).to receive(:dig).and_call_original
      allow(Rails.application.secrets).to receive(:dig).with(:decidim, :reminder, :unconfirmed_email, :days).and_return(3)
    end

    it "send a unique email to user created there is 3 days ago" do
      expect { subject.new.perform }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe "#unconfirmed_users" do
    it "returns the unconfirmed users" do
      expect(subject.new.send(:unconfirmed_users)).to match_array(unconfirmed_users)
    end
  end
end
