# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Initiatives
    module Admin
      describe UnpublishInitiative do
        subject { described_class.new(initiative, user) }

        let!(:initiative) { create :initiative }
        let(:blog) { create :component, participatory_space: initiative, manifest_name: "blogs" }
        let!(:key) { "jv5f8e" }
        let!(:awesome_config) { create :awesome_config, organization: initiative.organization, var: :scoped_admins, value: { "#{key}": initiative.author.id } }
        let!(:awesome_config_scoped) { create :awesome_config, organization: initiative.organization, var: "scoped_admin_#{key}", value: nil }
        let!(:settings) { { component_id: blog.id, participatory_space_slug: initiative.slug, participatory_space_manifest: "initiatives" } }
        let!(:awesome_constraint) { create :config_constraint, awesome_config: awesome_config_scoped, settings: settings }
        let!(:user) { create :user, :admin, :confirmed, organization: initiative.organization }

        context "when the initiative is already unpublished" do
          let(:initiative) { create :initiative, :created }

          it "broadcasts :invalid" do
            expect { subject.call }.to broadcast(:invalid)
          end
        end

        context "when everything is ok" do
          it "unpublishes the initiative" do
            expect { subject.call }.to change(initiative, :state).from("published").to("discarded")
          end

          it "traces the action", versioning: true do
            expect(Decidim.traceability)
              .to receive(:perform_action!)
              .with(:unpublish, initiative, user)
              .and_call_original

            expect { subject.call }.to change(Decidim::ActionLog, :count)
            action_log = Decidim::ActionLog.last
            expect(action_log.version).to be_present
          end

          it "removes the author from the scoped admins" do
            expect { subject.call }.to change { Decidim::DecidimAwesome::ConfigConstraint.all.length }.by(-1)
            expect(Decidim::DecidimAwesome::AwesomeConfig.find_by(var: :scoped_admins, organization: initiative.organization).value).to eq({})
          end
        end
      end
    end
  end
end
