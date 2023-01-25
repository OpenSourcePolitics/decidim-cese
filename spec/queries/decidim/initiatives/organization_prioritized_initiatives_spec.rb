# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Initiatives
    describe OrganizationPrioritizedInitiatives do
      subject { described_class.new(organization, order) }

      let(:organization) { create(:organization) }
      let!(:user) { create(:user, :confirmed, organization: organization) }
      let!(:initiatives) { create_list :initiative, 5, organization: organization }
      let!(:most_popular_initiative) { create :initiative, :published, organization: organization }
      let!(:most_recent_initiative) { create :initiative, published_at: 1.day.from_now, organization: organization }
      let!(:initiative_votes) { create_list :initiative_user_vote, 5, initiative: most_popular_initiative }

      context "when querying by default order" do
        let(:order) { "default" }

        it "returns initiatives ordered by least recent" do
          expect(subject.count).to eq(7)
          expect(subject.query.last).to eq(most_recent_initiative)
        end
      end

      context "when there is unpublished initiative" do
        let(:order) { "default" }
        let!(:unpublished) { create(:initiative, :unpublished, organization: organization) }

        it "does not return initiative" do
          expect(subject.count).to eq(7)
          expect(subject.query.last).to eq(most_recent_initiative)
        end
      end

      context "when there is initiative from other organization" do
        let(:order) { "default" }
        let!(:other_organization) { create(:initiative) }

        it "does not return initiative" do
          expect(subject.count).to eq(7)
          expect(subject.query.last).to eq(most_recent_initiative)
        end
      end

      context "when querying by most recent order" do
        let(:order) { "most_recent" }

        it "returns initiatives ordered by most recent" do
          expect(subject.count).to eq(7)
          expect(subject.query.first).to eq(most_recent_initiative)
        end
      end

      context "when querying by most popular order" do
        let(:order) { "most_popular" }

        it "returns initiatives ordered by most popular" do
          expect(subject.count).to eq(7)
          expect(subject.query.first).to eq(most_popular_initiative)
        end
      end

      context "when querying by random" do
        let(:order) { "random" }

        it "returns initiatives ordered randomly" do
          expect(subject.count).to eq(7)
        end
      end
    end
  end
end
