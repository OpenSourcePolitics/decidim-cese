# frozen_string_literal: true

module InitiativeHelperExtends
  def authorized_create_modal_button(type, html_options, &block)
    tag = "button"
    html_options ||= {}

    if current_user
      if action_authorized_to("create", permissions_holder: type).ok?
        html_options["data-open"] = "not-authorized-modal"
      else
        html_options["data-open"] = "authorizationModal"
        html_options["data-open-url"] = authorization_create_modal_initiative_path(type)
      end
    else
      html_options["data-open"] = "loginModal"
    end

    html_options["onclick"] = "event.preventDefault();"

    send("#{tag}_to", "", html_options, &block)
  end

  def i18n_options
    authorization = Decidim::Authorization.where(user: current_initiative.author, name: "extended_socio_demographic_authorization_handler").first
    name = if authorization
             "#{authorization.metadata["first_name"]} #{authorization.metadata["last_name"]}"
           else
             current_initiative.author.name
           end
    @i18n_options = {
      name: name,
      title: translated_attribute(current_initiative.title),
      publication_date: current_initiative.published_at.to_date,
      end_date: current_initiative.signature_end_date
    }
  end

  def signature_image_tag
    return if ENV["IMG_SIGNATURE"].blank?

    image_tag "data:image/png;base64,#{ENV.fetch("IMG_SIGNATURE", nil)}", width: "250"
  end

  def cachet_image_tag
    return if ENV["IMG_CACHET"].blank?

    image_tag "data:image/png;base64,#{ENV.fetch("IMG_CACHET", nil)}", width: "200"
  end
end

Decidim::Initiatives::InitiativeHelper.class_eval do
  include(InitiativeHelperExtends)
end
