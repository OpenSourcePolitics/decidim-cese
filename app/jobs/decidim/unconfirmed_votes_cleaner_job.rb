# frozen_string_literal: true

module Decidim
  class UnconfirmedVotesCleanerJob < ApplicationJob
    def perform
      unconfirmed_users.each do |user|
        votes = Decidim::InitiativesVote.includes(:initiative)
                                        .where(author: user)
        next if votes.blank?

        initiatives = votes.map(&:initiative)
        votes.destroy_all
        Decidim::UnconfirmedVotesClearMailer.send_resume(user, initiatives).deliver_now
      end
    end

    private

    def unconfirmed_users
      @unconfirmed_users ||= Decidim::User.not_confirmed
                                          .where("DATE(decidim_users.created_at) = ?", 7.days.ago.to_date)
                                          .joins("JOIN decidim_initiatives_votes ON decidim_users.id = decidim_initiatives_votes.decidim_author_id")
                                          .distinct
    end
  end
end
