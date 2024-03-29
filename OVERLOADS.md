# Overrides
## Disable username edition in user account
* 'app/views/decidim/account/show.html.erb:27'
```ruby
      <%= f.text_field :name, autocomplete: "name", readonly: "readonly" %>
```

## Update France Connect with requirements
* `app/views/decidim/devise/passwords/new.html.erb`
* `app/views/decidim/shared/_login_modal.html.erb`

## Admin Password Strong
Disable ask for new password when login as admin (only for development mode)
* `config/environments/development.rb:58`

## Update Create initiative command flow
Create a specific permission for comments on each initiative creation. Only active if ENV var `AH_INITIATIVES_COMMENT` defined and not empty

* `lib/extends/commends/decidim/initiatives/create_initiative_extends.rb`

## Load decidim-awesome assets only if dependencie is present
* `app/views/layouts/decidim/_head.html.erb:33`

## Fix geocoded proposals
* `app/controllers/decidim/proposals/proposals_controller.rb:44`
```ruby
          @all_geocoded_proposals = @base_query.geocoded.where.not(latitude: Float::NAN, longitude: Float::NAN)
```

##  Fix meetings registration serializer
* `app/serializers/decidim/meetings/registration_serializer.rb`
## Fix UserAnswersSerializer for CSV exports
* `lib/decidim/forms/user_answers_serializer.rb`
## 28c8d74 - Add basic tests to reference package (#1), 2021-07-26
* `lib/extends/commands/decidim/admin/create_participatory_space_private_user_extends.rb`
* `lib/extends/commands/decidim/admin/impersonate_user_extends.rb`
##  cd5c2cc - Backport fix/user answers serializer (#11), 2021-09-30
* `lib/decidim/forms/user_answers_serializer.rb`
## Fix metrics issue in admin dashboard
 - **app/stylesheets/decidim/vizzs/_areachart.scss**
```scss
    .area{
        fill: rgba($primary, .2);;
    }
```

## Add FC Connect SSO
 - **app/views/decidim/devise/shared/_omniauth_buttons.html.erb**
```ruby
<% if provider.match?("france") %>
```

* `app/views/decidim/scopes/picker.html.erb`
c76437f - Modify cancel button behaviour to match close button, 2022-02-08

* `app/helpers/decidim/backup_helper.rb`
83830be - Add retention service for daily backups (#19), 2021-11-09

* `app/services/decidim/s3_retention_service.rb`
de6d804 - fix multipart object tagging (#40) (#41), 2021-12-24

* `config/initializers/omniauth_publik.rb`
9d50925 - Feature omniauth publik (#46), 2022-01-18

* `lib/tasks/restore_dump.rake`
705e0ad - Run rubocop, 2021-12-01

## Add recepisse
* `app/controllers/decidim/initiatives/initiatives_controller.rb`
* `app/permissions/decidim/initiatives/permissions.rb`
* `app/views/decidim/initiatives/initiatives/print.html.erb`
* `app/views/decidim/initiatives/initiatives/show.html.erb`
* `app/permissions/decidim/initiatives/permissions.rb`
