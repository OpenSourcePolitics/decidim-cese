# frozen_string_literal: true

class AddSecretsImageToOrganization < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_organizations, :official_cachet, :string
    add_column :decidim_organizations, :official_signature, :string
  end
end
