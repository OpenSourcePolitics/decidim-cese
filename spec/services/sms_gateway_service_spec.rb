# frozen_string_literal: true

require "spec_helper"

describe SMSGatewayService do
  subject { described_class.new(mobile_phone_number, code) }

  let(:mobile_phone_number) { "0600000000" }
  let(:code) { "0123456" }

  it "allows to setup service" do
    expect(subject.mobile_phone_number).to eq("0600000000")
    expect(subject.code).to eq("0123456")
  end

  describe "#deliver_code" do
    let(:api_url) { "https://ssl.etoilediese.fr/envoi/sms/envoi.php?f=sms&n=0600000000&p=api_password&t=Hello,%20here%20is%20the%20code%20to%20authenticate%20yourself%20on%20the%20CESE%20initiatives%20platform:%200123456&u=api_username" }
    let(:api_username) { "api_username" }
    let(:api_password) { "api_password" }
    let(:response_body) { "123456789" }

    before do
      allow(Rails.application.secrets).to receive(:dig).with(:decidim, :verifications, :sms_gateway_service, :username).and_return(api_username)
      allow(Rails.application.secrets).to receive(:dig).with(:decidim, :verifications, :sms_gateway_service, :password).and_return(api_password)
      stub_request(:get, api_url)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Host" => "ssl.etoilediese.fr",
            "User-Agent" => "Ruby"
          }
        )
        .to_return(status: 200, body: response_body, headers: {})
    end

    it "send request to external service" do
      expect(subject.deliver_code).to be_truthy
    end

    context "when credentials are missing" do
      let(:response_body) { "Echec: Veuillez vous identifier" }

      it "rescue error and returns false" do
        expect(subject.deliver_code).to be_falsey
      end
    end

    context "when message translation contains special chars" do
      let(:api_url) { "https://ssl.etoilediese.fr/envoi/sms/envoi.php?f=sms&n=0600000000&p=api_password&t=Hello,%20here%20is%20the%20code%20to%20authenticate%20yourself%20on%20the%20CESE%20initiatives%20platform:%200123456&u=api_username" }

      before do
        allow(I18n).to receive(:t).with("sms_verification_workflow.message", code: code).and_return("Hello, here is the code to authenticate yourself on pétitions: 0123456")
      end

      it "rescue error and returns false" do
        expect(subject.deliver_code).to be_falsey
      end
    end
  end
end
