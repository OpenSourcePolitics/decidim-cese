# frozen_string_literal: true

# This migration comes from decidim (originally 20190412131728)

class FixUserNames < ActiveRecord::Migration[5.2]
  def change
    # Comes from Decidim::User specs
    weird_characters =
      ["<", ">", "?", "\\%", "&", "^", "*", "#", "@", "(", ")", "[", "]", "=", "+", ":", ";", "\"", "{", "}", "\\", "|", "/"]
    characters_to_remove = "<>?%&^*\#@()[]=+:;\"{}\\|/"

    weird_characters.each do |character|
      Decidim::UserBaseEntity.where(deleted_at: nil).where("name like '%#{character}%' escape '\' OR nickname like '%#{character}%' escape '\'").find_each do |entity|
        Rails.logger.debug { "detected character: #{character}" }
        Rails.logger.debug { "UserBaseEntity ID: #{entity.id}" }
        Rails.logger.debug { "#{entity.name} => #{entity.name.delete(characters_to_remove).strip}" }
        Rails.logger.debug { "#{entity.nickname} => #{entity.nickname.delete(characters_to_remove).strip}" }

        entity.name = entity.name.delete(characters_to_remove).strip
        sanitized_nickname = entity.nickname.delete(characters_to_remove).strip
        # rubocop:disable Rails/SkipsModelValidations
        entity.update_columns(nickname: Decidim::UserBaseEntity.nicknamize(sanitized_nickname, organization: entity.organization))
        # rubocop:enable Rails/SkipsModelValidations
      end
    end
  end
end
