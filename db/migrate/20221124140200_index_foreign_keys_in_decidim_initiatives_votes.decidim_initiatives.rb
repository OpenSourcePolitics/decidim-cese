# frozen_string_literal: true

# This migration comes from decidim_initiatives (originally 20200320105921)

class IndexForeignKeysInDecidimInitiativesVotes < ActiveRecord::Migration[5.2]
  def change
    add_index :decidim_initiatives_votes, :decidim_user_group_id, if_not_exists: true
    add_index :decidim_initiatives_votes, :hash_id, if_not_exists: true
  end
end
