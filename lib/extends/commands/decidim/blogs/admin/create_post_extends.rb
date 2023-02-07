# frozen_string_literal: true

module Decidim
  module Blogs
    module Admin
      module CreatePostExtends
        def call
          return broadcast(:invalid) if @form.invalid?

          transaction do
            create_post!
            send_notification
          end

          @post.participatory_space.followers.each do |follower|
            Decidim::Blogs::BlogsMailer
              .notify_post(@post, follower, @post.participatory_space)
              .deliver_later
          end

          broadcast(:ok, @post)
        end
      end
    end
  end
end

Decidim::Blogs::Admin::CreatePost.class_eval do
  prepend Decidim::Blogs::Admin::CreatePostExtends
end
