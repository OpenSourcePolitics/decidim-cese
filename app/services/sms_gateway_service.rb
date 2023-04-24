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
    @username = Rails.application.secrets.dig(:decidim, :verifications, :sms_gateway_service, :username)
    @password = Rails.application.secrets.dig(:decidim, :verifications, :sms_gateway_service, :password)
    @message = I18n.t("sms_verification_workflow.message", code: code)
    @type = "sms"
  end

  def deliver_code
    url = URI("#{@url}?u=#{@username}&p=#{@password}&t=#{@message}&n=#{@mobile_phone_number}&f=#{@type}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    response = https.get(url)
    res_body = response.read_body
    raise ArgumentError, res_body if res_body.include?("Echec")

    Rails.logger.info("#########################################################")
    Rails.logger.info("SMS Verification code delivered to #{mobile_phone_number}")
    Rails.logger.info("SMS Verification API response #{res_body}")
    Rails.logger.info("#########################################################")

    true
  rescue URI::InvalidURIError => e
    Rails.logger.error("[SMSGatewayService] - Error #{e.message}")
    Rails.logger.error("[SMSGatewayService] - Ensure there is no special chars in I18n translation : 'sms_verification_workflow.message'")

    false
  rescue ArgumentError => e
    Rails.logger.error("[SMSGatewayService] - Error '#{e.message}'")
    Rails.logger.error("[SMSGatewayService] - Ensure env variable 'SMS_GATEWAY_USERNAME' and 'SMS_GATEWAY_PASSWORD' are defined")

    false
  end
end
