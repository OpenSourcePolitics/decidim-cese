# frozen_string_literal: true

module CreateInitiativeControllerExtends
  extend ActiveSupport::Concern

  included do
    helper Decidim::Initiatives::SignatureTypeOptionsHelper

    def show
      send("#{step}_step", initiative: session_initiative)
    end

    def update
      enforce_permission_to :create, :initiative, { initiative_type: initiative_type_from_params }
      send("#{step}_step", params)
    end

    private

    def show_similar_initiatives_step(parameters)
      @form = build_form(Decidim::Initiatives::PreviousForm, parameters)
      unless @form.valid?
        redirect_to previous_wizard_path(validate_form: true)
        return
      end

      if similar_initiatives.empty?
        @form = build_form(Decidim::Initiatives::InitiativeForm, parameters)
        redirect_to wizard_path(:fill_data)
      end

      render_wizard unless performed?
    end

    def previous_form_step(parameters)
      @form = build_form(Decidim::Initiatives::PreviousForm, parameters)

      enforce_permission_to :create, :initiative, { initiative_type: initiative_type }

      render_wizard
    end

    def initiative_type_from_params
      Decidim::InitiativesType.find_by(id: params["initiative"]["type_id"])
    end
  end
end

Decidim::Initiatives::CreateInitiativeController.class_eval do
  include(CreateInitiativeControllerExtends)
end
