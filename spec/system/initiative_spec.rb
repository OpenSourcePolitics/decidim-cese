# frozen_string_literal: true

require "spec_helper"

describe "Initiative", type: :system do
  let(:organization) { create(:organization) }
  let(:state) { :published }
  let!(:user) { create(:user, :confirmed, organization: organization) }
  let(:base_initiative) do
    create(:initiative, organization: organization, state: state)
  end

  before do
    switch_to_host(organization.host)
    login_as(user, scope: :user)
  end

  context "when the initiative does not exist" do
    it_behaves_like "a 404 page" do
      let(:target_path) { decidim_initiatives.initiative_path(99_999_999) }
    end
  end

  describe "initiative page" do
    let!(:initiative) { base_initiative }
    let(:attached_to) { initiative }

    context "when requesting the initiative path" do
      before do
        visit decidim_initiatives.initiative_path(initiative)
      end

      shared_examples_for "initiative shows signatures" do
        it "shows signatures for the state" do
          expect(page).to have_css(".progress__bar__number")
          expect(page).to have_css(".progress__bar__text")
        end
      end

      shared_examples_for "initiative does not show signatures" do
        it "does not show signatures for the state" do
          expect(page).not_to have_css(".progress__bar__number")
          expect(page).not_to have_css(".progress__bar__text")
        end
      end

      shared_examples_for "initiative shows recepisse link" do
        it "shows recepisse link" do
          expect(page).to have_link("Show receipt")
        end
      end

      shared_examples_for "initiative does not show recepisse link" do
        it "does not show recepisse link" do
          expect(page).not_to have_link("Show receipt")
        end
      end

      it "shows the details of the given initiative" do
        within "main" do
          expect(page).to have_content(translated(initiative.title, locale: :en))
          expect(page).to have_content(ActionView::Base.full_sanitizer.sanitize(translated(initiative.description, locale: :en), tags: []))
          expect(page).to have_content(translated(initiative.type.title, locale: :en))
          expect(page).to have_content(translated(initiative.scope.name, locale: :en))
          expect(page).to have_content(initiative.author_name)
          expect(page).to have_content(initiative.hashtag)
          expect(page).to have_content(initiative.reference)
        end
      end

      context "when signature interval is defined" do
        let(:base_initiative) do
          create(:initiative,
                 organization: organization,
                 signature_start_date: 1.day.ago,
                 signature_end_date: 1.day.from_now,
                 state: state)
        end

        it "displays collection period" do
          within ".process-header__phase" do
            expect(page).to have_content("Signature collection period")
            expect(page).to have_content(1.day.ago.strftime("%Y-%m-%d"))
            expect(page).to have_content(1.day.from_now.strftime("%Y-%m-%d"))
          end
        end
      end

      it_behaves_like "initiative shows signatures"
      it_behaves_like "initiative does not show recepisse link"

      it "shows the author name once in the authors list" do
        within ".initiative-authors" do
          expect(page).to have_content(initiative.author_name, count: 1)
        end
      end

      context "when initiative state is rejected" do
        let(:state) { :rejected }

        it_behaves_like "initiative shows signatures"
        it_behaves_like "initiative does not show recepisse link"
      end

      context "when initiative state is accepted" do
        let(:state) { :accepted }

        it_behaves_like "initiative shows signatures"
        it_behaves_like "initiative does not show recepisse link"
      end

      context "when initiative state is created" do
        let(:state) { :created }

        it_behaves_like "initiative does not show signatures"
        it_behaves_like "initiative does not show recepisse link"
      end

      context "when initiative state is validating" do
        let(:state) { :validating }

        it_behaves_like "initiative does not show signatures"
        it_behaves_like "initiative does not show recepisse link"
      end

      context "when initiative state is discarded" do
        let(:state) { :discarded }

        it_behaves_like "initiative does not show signatures"
        it_behaves_like "initiative does not show recepisse link"
      end

      context "when initiative author is the current user" do
        let(:initiative) { create(:initiative, organization: organization, state: state, author: user) }

        it_behaves_like "initiative shows recepisse link"
      end

      it_behaves_like "has attachments"

      it "displays comments section" do
        expect(page).to have_css(".comments")
        expect(page).to have_content("0 Comments")
      end

      context "when initiative state is illegal" do
        let(:state) { :illegal }

        before do
          relogin_as initiative.author
          visit decidim_initiatives.initiative_path(initiative)
        end

        it_behaves_like "initiative does not show signatures"

        it "does not show content" do
          within "main" do
            expect(page).not_to have_content(translated(initiative.title, locale: :en))
            expect(page).not_to have_content(ActionView::Base.full_sanitizer.sanitize(translated(initiative.description, locale: :en), tags: []))
            expect(page).to have_content("Title content moderated")
            expect(page).to have_content("Description content moderated")
          end
        end

        it "displays initiative moderated title in title tab" do
          expect(page).not_to have_title("#{translated(initiative.title)} - #{translated(initiative.title)} - #{organization.name}")
          expect(page).to have_title("Title content moderated - Title content moderated - #{organization.name}")
        end
      end
    end
  end
end
