# frozen_string_literal: true

require "spec_helper"
require "decidim/duplicates_metadata"

describe Decidim::DuplicatesMetadata do
  subject { described_class.new }

  let(:organization) { create(:organization) }

  let!(:user) { create(:user, organization: organization) }
  let!(:user2) { create(:user, organization: organization) }

  let!(:socio_authorization) do
    create(:authorization,
           user: user,
           metadata: { "email" => "user@example.org", "postal_code" => "12345", "city" => "Barcelona", "phone_number" => "01234567889" },
           name: "extended_socio_demographic_authorization_handler")
  end
  let!(:socio_authorization_user2) do
    create(:authorization,
           user: user2,
           metadata: { "email" => "user2@example.org", "postal_code" => "54321", "city" => "Paris", "phone_number" => "9876543210" },
           name: "extended_socio_demographic_authorization_handler")
  end

  it "has :authorizations attr_reader" do
    expect(subject.authorizations.count).to eq(2)
  end

  describe "#perform" do
    it "updates users extended_data" do
      expect(user.extended_data).not_to include("extended_socio_demographic_authorization_handler")
      expect(user2.extended_data).not_to include("extended_socio_demographic_authorization_handler")

      subject.perform
      user.reload
      user2.reload

      expect(user.extended_data).to include(
        "extended_socio_demographic_authorization_handler" => socio_authorization.metadata,
      )

      expect(user2.extended_data).to include(
        "extended_socio_demographic_authorization_handler" => socio_authorization_user2.metadata,
      )
    end

    context "when there is no authorizations" do
      before do
        Decidim::Authorization.destroy_all
      end

      it "does not update user" do
        expect do
          subject.perform
          user.reload
        end.not_to change(user, :extended_data)

        expect(subject.authorizations.count).to eq(0)
      end
    end
  end
end
