# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Initiatives
    describe InitiativePrintHelper do
      describe "#i18n_options" do
        before do
          allow(helper).to receive(:current_initiative).and_return(initiative)
        end

        context "when the author has completed the authorization" do
          let(:user) { create(:user, :confirmed, organization: organization) }
          let(:initiative) { create(:initiative, :published, organization: organization, author: user) }
          let(:organization) { create(:organization) }

          before do
            Decidim::Authorization.create!(
              user: user,
              name: "extended_socio_demographic_authorization_handler",
              metadata: {
                first_name: "John",
                last_name: "Doe"
              }
            )
          end

          it "returns a hash" do
            expect(helper.i18n_options).to eq({
                                                name: "John Doe",
                                                title: initiative.title["en"],
                                                publication_date: initiative.published_at.to_date.strftime("%d/%m/%Y"),
                                                end_date: initiative.signature_end_date.strftime("%d/%m/%Y")
                                              })
          end
        end

        context "when the author has not completed the authorization" do
          let(:user) { create(:user, :confirmed, organization: organization) }
          let(:initiative) { create(:initiative, :published, organization: organization, author: user) }
          let(:organization) { create(:organization) }

          it "returns a hash" do
            expect(helper.i18n_options).to eq({
                                                name: user.name,
                                                title: initiative.title["en"],
                                                publication_date: initiative.published_at.to_date.strftime("%d/%m/%Y"),
                                                end_date: initiative.signature_end_date.strftime("%d/%m/%Y")
                                              })
          end
        end
      end

      describe "signature_image_tag" do
        context "when the env field is completed" do
          before do
            allow(ENV).to receive(:fetch).and_call_original
            allow(ENV).to receive(:fetch).with("IMG_SIGNATURE", nil).and_return("data:image/png;base64,signature_en_base_64")
          end

          it "returns a valid image tag" do
            expect(signature_image_tag).to eq("<img width=\"250\" src=\"data:image/png;base64,signature_en_base_64\" />")
          end
        end

        context "when the env field is not completed" do
          before do
            allow(ENV).to receive(:fetch).and_call_original
            allow(ENV).to receive(:fetch).with("IMG_SIGNATURE", nil).and_return(nil)
          end

          it "returns nothing" do
            expect(signature_image_tag).to be_nil
          end
        end

        context "when the env field is badly completed" do
          before do
            allow(ENV).to receive(:fetch).and_call_original
            allow(ENV).to receive(:fetch).with("IMG_SIGNATURE", nil).and_return("signature_en_base_64")
          end

          it "returns a nothing" do
            expect(signature_image_tag).to be_nil
          end
        end
      end

      describe "cachet_image_tag" do
        context "when the env field is completed" do
          before do
            allow(ENV).to receive(:fetch).and_call_original
            allow(ENV).to receive(:fetch).with("IMG_CACHET", nil).and_return("data:image/png;base64,cachet_en_base_64")
          end

          it "returns a valid image tag" do
            expect(cachet_image_tag).to eq("<img width=\"200\" src=\"data:image/png;base64,cachet_en_base_64\" />")
          end
        end

        context "when the env field is not completed" do
          before do
            allow(ENV).to receive(:fetch).and_call_original
            allow(ENV).to receive(:fetch).with("IMG_CACHET", nil).and_return(nil)
          end

          it "returns nothing" do
            expect(cachet_image_tag).to be_nil
          end
        end

        context "when the env field is badly completed" do
          before do
            allow(ENV).to receive(:fetch).and_call_original
            allow(ENV).to receive(:fetch).with("IMG_CACHET", nil).and_return("cachet_en_base_64")
          end

          it "returns a nothing" do
            expect(cachet_image_tag).to be_nil
          end
        end
      end
    end
  end
end
