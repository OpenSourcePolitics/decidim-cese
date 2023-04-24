# frozen_string_literal: true

module OrganizationPrioritizedInitiativesExtends
  def query
    case order
    when "random"
      base_query.order_randomly(random_seed)
    when "most_popular"
      base_query.order_by_supports
    when "most_recent"
      base_query.order_by_most_recently_published
    else
      base_query
    end
  end

  def random_seed
    @random_seed ||= ((rand * 2) - 1).to_f
  end
end

Decidim::Initiatives::OrganizationPrioritizedInitiatives.class_eval do
  prepend OrganizationPrioritizedInitiativesExtends
end
