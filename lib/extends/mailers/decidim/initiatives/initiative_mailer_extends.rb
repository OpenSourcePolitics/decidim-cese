# frozen_string_literal: true

module InitiativesMailerExtends
  def notify_answer(initiative, user)
    return if user.email.blank?
    return unless user.follows?(initiative)

    @organization = initiative.organization
    @link = initiative_url(initiative, host: @organization.host)
    @answer = translated_attribute(initiative.answer).gsub(%r{</?[^>]*>}, "") if initiative.answer.present?

    with_user(user) do
      @body = I18n.t(
        "decidim.initiatives.initiatives_mailer.answer_body_for",
        title: translated_attribute(initiative.title)
      )

      @subject = I18n.t(
        "decidim.initiatives.initiatives_mailer.answer_for",
        title: translated_attribute(initiative.title)
      )

      mail(to: "#{user.name} <#{user.email}>", subject: @subject)
    end
  end
end

Decidim::Initiatives::InitiativesMailer.prepend(InitiativesMailerExtends)
