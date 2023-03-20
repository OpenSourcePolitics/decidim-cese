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
end

Decidim::Initiatives::InitiativeHelper.class_eval do
  include(InitiativeHelperExtends)
end
