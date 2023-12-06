# frozen_string_literal: true

require "spec_helper"

describe Decidim::UnconfirmedVotesCleanerJob do
  subject { described_class }

  let!(:unconfirmed_users) { create_list(:user, 2, created_at: 7.days.ago) }
  let!(:confirmed_user) { create(:user, :confirmed, created_at: 7.days.ago) }
  let!(:unconfirmed_votes) { create_list(:initiative_user_vote, 3, author: unconfirmed_users.first) }
  let!(:confirmed_votes) { create_list(:initiative_user_vote, 3, author: confirmed_user) }

  before do
    create(:user, created_at: 30.days.ago)
    create(:user, :confirmed, created_at: 2.days.ago)
    create(:user, created_at: 1.day.ago)
  end

  it "sends a reminder to unconfirmed users" do
    expect { subject.new.perform }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  describe "#unconfirmed_users" do
    it "returns the unconfirmed user with initiatives votes" do
      expect(subject.new.send(:unconfirmed_users).count).to eq(1)
      expect(subject.new.send(:unconfirmed_users)).to include(unconfirmed_users.first)
      expect(subject.new.send(:unconfirmed_users)).not_to include(unconfirmed_users.last)
    end
  end
end
