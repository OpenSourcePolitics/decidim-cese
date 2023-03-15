# frozen_string_literal: true

# This migration comes from decidim_initiative_status (originally 20230214150502)

class AddStatusToInitiatives < ActiveRecord::Migration[6.1]
  def change
    add_reference :decidim_initiatives, :decidim_status, index: true
  end
end
