# frozen_string_literal: true

# This migration comes from decidim_initiative_status (originally 20230214150449)

class CreateDecidimStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_statuses do |t|
      t.jsonb :name
      t.references :decidim_organization, foreign_key: true, index: true
      t.timestamps
    end
  end
end
