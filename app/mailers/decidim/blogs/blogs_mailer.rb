# frozen_string_literal: true

module Decidim
  module Blogs
    class BlogsMailer < Decidim::ApplicationMailer
      include Decidim::TranslatableAttributes
      include Decidim::SanitizeHelper

      helper Decidim::TranslatableAttributes
      helper Decidim::SanitizeHelper

      def notify_post(post, user, initiative)
        return if user.email.blank?
        return unless user.follows?(initiative)

        @organization = post.organization
        @link = resource_locator(post).path

        @body = I18n.t(
          "decidim.blogs.blogs_mailer.notify_post.body",
          author: post.author.name,
          title: translated_attribute(initiative.title),
          post_title: translated_attribute(post.title)
        )

        @subject = I18n.t(
          "decidim.blogs.blogs_mailer.notify_post.subject",
          title: translated_attribute(initiative.title)
        )

        mail(to: "#{user.name} <#{user.email}>", subject: @subject)
      end

      private

      def resource_locator(resource)
        Decidim::ResourceLocatorPresenter.new(resource)
      end
    end
  end
end
