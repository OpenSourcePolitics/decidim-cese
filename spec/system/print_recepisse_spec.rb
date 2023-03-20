# frozen_string_literal: true

require "spec_helper"

describe "User prints the recepisse of the initiative", type: :system do
  context "when initiative print" do
    include_context "when admins initiative"
    let(:state) { :published }
    let!(:initiative) do
      create(:initiative, organization: organization, scoped_type: initiative_scope, author: author, state: state)
    end

    before do
      switch_to_host(organization.host)
      login_as author, scope: :user
      visit decidim_initiatives.initiative_path(initiative)
    end

    context "when you are the author" do
      context "when published" do
        it "shows a link when published" do
          expect(page).to have_selector(".action-print")
        end

        it "shows a printable page when clicking" do
          page.find(".action-print").click
          within "main" do
            expect(page).to have_content(translated(initiative.title, locale: :en))
          end
        end
      end

      context "when sent to technical validation" do
        let(:state) { :validating }

        it "doesn't show a link when published" do
          expect(page).not_to have_selector(".action-print")
        end
      end
    end

    context "when you are not the author" do
      let(:user2) { create(:user, :admin, :confirmed, organization: organization) }

      before do
        login_as user2, scope: :user
        visit decidim_initiatives.initiative_path(initiative)
      end

      it "doesn't show a link when published" do
        expect(page).not_to have_selector(".action-print")
      end
    end
  end
end
