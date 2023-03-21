# frozen_string_literal: true

# This migration comes from decidim_initiatives (originally 20200320105920)

class IndexForeignKeysInDecidimInitiatives < ActiveRecord::Migration[5.2]
  def change
    add_index :decidim_initiatives, :decidim_user_group_id, if_not_exists: true
    add_index :decidim_initiatives, :scoped_type_id, if_not_exists: true
  end
end
