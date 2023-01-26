# frozen_string_literal: true

module UnpublishInitiativeExtends
  def call
    return broadcast(:invalid) unless initiative.published?

    @initiative = Decidim.traceability.perform_action!(
      :unpublish,
      initiative,
      current_user
    ) do
      initiative.unpublish!
      unpromote_creator
      initiative
    end
    broadcast(:ok, initiative)
  end

  private

  def unpromote_creator
    Decidim::DecidimAwesome::AwesomeConfig.find_by(var: :scoped_admins, organization: @initiative.organization).value.each do |key, value|
      next unless value == initiative.author.id

      Decidim::DecidimAwesome::ConfigConstraint.find_by(
        awesome_config: Decidim::DecidimAwesome::AwesomeConfig.find_by(var: "scoped_admin_#{key}", organization: @initiative.organization),
        settings: { component_id: @initiative.components.find_by(manifest_name: "blogs").id, participatory_space_slug: @initiative.slug,
                    participatory_space_manifest: "initiatives" }
      ).destroy!
      Decidim::DecidimAwesome::AwesomeConfig.find_by(var: "scoped_admin_#{key}", organization: @initiative.organization).destroy!
      Decidim::DecidimAwesome::AwesomeConfig.find_by(var: :scoped_admins, organization: @initiative.organization).update!(
        value: Decidim::DecidimAwesome::AwesomeConfig.find_by(var: :scoped_admins, organization: @initiative.organization).value.except(key)
      )
    end
  end
end

Decidim::Initiatives::Admin::UnpublishInitiative.class_eval do
  prepend UnpublishInitiativeExtends
end
