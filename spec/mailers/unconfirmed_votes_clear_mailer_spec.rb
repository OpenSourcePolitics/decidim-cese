# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe UnconfirmedVotesClearMailer, type: :mailer do
    let(:organization) { create(:organization) }
    let(:user) { create(:user, name: "Sarah Connor", organization: organization) }
    let(:unconfirmed_votes) { create_list(:initiative_user_vote, 3, author: user) }
    let(:initiatives) { unconfirmed_votes.map(&:initiative) }

    let(:confirmed_user) { create(:user, :confirmed, organization: organization) }
    let(:confirmed_votes) { create_list(:initiative_user_vote, 3, author: confirmed_user) }

    describe "#send_resume" do
      let(:mail) { described_class.send_resume(user, initiatives) }

      it "parses the subject" do
        expect(mail.subject).to eq("You did not confirm your account, existing votes have been deleted")
      end

      it "parses the body" do
        expect(email_body(mail)).to include("You did not confirm your account, existing votes have been deleted")
        expect(email_body(mail)).to include("You can still confirm your account and vote again on initiatives.")
        initiatives.each do |initiative|
          expect(email_body(mail)).to include("Your vote on #{translated(initiative.title)} has been deleted.")
        end
      end

      context "when the user has a different locale" do
        before do
          user.locale = "fr"
          user.save!
        end

        it "parses the subject in the user's locale" do
          expect(mail.subject).to eq("Vous n'avez pas confirmé votre compte, vos votes ont été supprimés")
        end

        it "parses the body in the user's locale" do
          expect(email_body(mail)).to include("Vous n'avez pas confirmé votre compte, les votes que vous avez fait ont été supprimés")
          expect(email_body(mail)).to include("Vous pouvez toujours confirmer votre compte et voter à nouveau sur les pétitions.")
          initiatives.each do |initiative|
            expect(email_body(mail)).to include("Votre vote sur la pétition '#{translated(initiative.title)}' a été supprimé.")
          end
        end
      end
    end
  end
end
