# frozen_string_literal: true

module HighlightedInitiativesSettingsFormCellExtends
  def order_select
    [
      [I18n.t("decidim.initiatives.admin.content_blocks.highlighted_initiatives.order.default"), "default"],
      [I18n.t("decidim.initiatives.admin.content_blocks.highlighted_initiatives.order.random"), "random"],
      [I18n.t("decidim.initiatives.admin.content_blocks.highlighted_initiatives.order.most_popular"), "most_popular"],
      [I18n.t("decidim.initiatives.admin.content_blocks.highlighted_initiatives.order.most_recent"), "most_recent"]
    ]
  end
end

Decidim::Initiatives::ContentBlocks::HighlightedInitiativesSettingsFormCell.class_eval do
  prepend(HighlightedInitiativesSettingsFormCellExtends)
end
