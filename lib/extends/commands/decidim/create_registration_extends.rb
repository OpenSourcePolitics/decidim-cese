# frozen_string_literal: true

module CreateRegistrationExtends
  private

  def create_user
    @user = Decidim::User.create!(
      email: form.email,
      name: form.name,
      nickname: form.nickname,
      password: form.password,
      password_confirmation: form.password_confirmation,
      organization: form.current_organization,
      tos_agreement: form.tos_agreement,
      newsletter_notifications_at: form.newsletter_at,
      accepted_tos_version: form.current_organization.tos_version,
      locale: form.current_locale,
      notifications_sending_frequency: :none
    )
  end
end

Decidim::CreateRegistration.class_eval do
  prepend(CreateRegistrationExtends)
end
