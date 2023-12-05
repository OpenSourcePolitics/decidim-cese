# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe ConfirmationReminderMailer, type: :mailer do
    let(:user) { create(:user, name: "Sarah Connor", organization: organization) }
    let(:organization) { create(:organization) }

    describe "#send_reminder" do
      let(:mail) { described_class.send_reminder(user) }

      it "parses the subject" do
        expect(mail.subject).to eq("Please confirm your email address")
      end

      it "parses the body" do
        expect(email_body(mail)).to include("You have created an account there is 2 days ago and you haven't confirmed your email yet.")
        expect(email_body(mail)).to include("Please confirm your email address to persist your votes.")
        expect(email_body(mail)).to include("If you don't confirm your email address, your votes will be deleted.")
      end

      context "when the user has a different locale" do
        before do
          user.locale = "fr"
          user.save!
        end

        it "parses the subject in the user's locale" do
          expect(mail.subject).to eq("Veuillez confirmer votre compte")
        end

        it "parses the body in the user's locale" do
          expect(email_body(mail)).to include("Vous avez créé un compte il y a 2 jours mais vous ne l'avez pas encore confirmé.")
          expect(email_body(mail)).to include("Veuillez confirmer votre compte en cliquant sur le lien ci-dessous.")
          expect(email_body(mail)).to include("L'ensemble de vos votes seront supprimés dans 6 jours si votre compte n'est pas confirmé dans ce délai.")
        end
      end
    end
  end
end
