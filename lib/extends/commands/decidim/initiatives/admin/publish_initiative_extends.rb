# frozen_string_literal: true

module PublishInitiativeExtends
  def call
    return broadcast(:invalid) if initiative.published?

    @organization = initiative.organization
    @initiative = Decidim.traceability.perform_action!(
      :publish,
      initiative,
      current_user,
      visibility: "all"
    ) do
      initiative.publish!
      increment_score
      promote_creator
      initiative
    end
    broadcast(:ok, initiative)
  end

  private

  def promote_creator
    Decidim::DecidimAwesome::Admin::CreateScopedAdmin.call(@organization) do
      on(:ok) do |key|
        setting = Decidim::DecidimAwesome::AwesomeConfig.find_or_initialize_by(var: :scoped_admins, organization: @organization)
        setting.value = { key => initiative.author.id }
        setting.save!
        update_constraint(key)
      end

      on(:invalid) do |message|
        Rails.logger.debug message
      end
    end
  end

  def update_constraint(key)
    Decidim::DecidimAwesome::ConfigConstraint.find_by(
      awesome_config: Decidim::DecidimAwesome::AwesomeConfig.find_by(var: "scoped_admin_#{key}", organization: @organization),
      settings: { "participatory_space_manifest" => "none" }
    ).update!(
      settings: { component_id: @initiative.components.find_by(manifest_name: "blogs").id, participatory_space_slug: @initiative.slug,
                  participatory_space_manifest: "initiatives" }
    )
  rescue ActiveRecord::RecordNotUnique
    Rails.logger.debug I18n.t("decidim.decidim_awesome.admin.constraints.errors.not_unique")
  rescue StandardError => e
    Rails.logger.debug e.message
  end
end

Decidim::Initiatives::Admin::PublishInitiative.class_eval do
  prepend PublishInitiativeExtends
end
