# frozen_string_literal: true

module Decidim
  module Initiatives
    module InitiativeHelperVoteModalOverride
      extend ActiveSupport::Concern

      included do
        def authorized_vote_modal_button(initiative, html_options, &block)
          return if current_user && action_authorized_to("vote", resource: initiative, permissions_holder: initiative.type).ok?

          tag = "button"
          html_options ||= {}

          html_options["data-after-action"] = "vote-initiative"

          if current_user
            html_options["data-open"] = "authorizationModal"
            html_options["data-open-url"] = authorization_sign_modal_initiative_path(initiative)
          else
            html_options["data-open"] = "loginModal"
          end

          html_options["onclick"] = "event.preventDefault();"

          send("#{tag}_to", "", html_options, &block)
        end
      end
    end
  end
end
