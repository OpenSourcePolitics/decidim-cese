# frozen_string_literal: true

class ApplicationMailer < Decidim::ApplicationMailer
  default from: "from@example.com"
  layout "send_reminder"
end
