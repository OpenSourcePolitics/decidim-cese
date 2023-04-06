# frozen_string_literal: true

class AddSecretsImageToOrganization < ActiveRecord::Migration[6.1]
  def up
    add_column :decidim_organizations, :official_cachet, :string
    add_column :decidim_organizations, :official_signature, :string
  end

  def down
    remove_column :decidim_organizations, :official_cachet
    remove_column :decidim_organizations, :official_signature
  end
end
