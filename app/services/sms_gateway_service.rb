# frozen_string_literal: true

require "uri"
require "net/http"

class SMSGatewayService
  include Rails.application.routes.url_helpers
  attr_reader :mobile_phone_number, :code

  def initialize(mobile_phone_number, code)
    @mobile_phone_number = mobile_phone_number
    @code = code
    @url = "https://ssl.etoilediese.fr/envoi/sms/envoi.php"
    @username = ENV.fetch("SMS_GATEWAY_USERNAME", nil)
    @password = ENV.fetch("SMS_GATEWAY_PASSWORD", nil)
    @message = I18n.t("sms_verification_workflow.message", code: code)
    @type = "sms"
  end

  def deliver_code
    url = URI("#{@url}?u=#{@username}&p=#{@password}&t=#{@message}&n=#{@mobile_phone_number}&f=#{@type}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = https.request(request)
    response = response.read_body

    Rails.logger.info("#########################################################")
    Rails.logger.info("SMS Verification code delivered to #{mobile_phone_number}")
    Rails.logger.info("SMS Verification API response #{response}")
    Rails.logger.info("#########################################################")
    true
  end
end