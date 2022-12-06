![Continuous Integration](https://github.com/OpenSourcePolitics/decidim-cese/actions/workflows/tests.yml/badge.svg)

# Decidim app by OSP

Citizen Participation and Open Government application using [Decidim](https://github.com/decidim/decidim) maintained by [Open Source Politics](https://github.com/OpenSourcePolitics/).


**Decidim version [v0.27.1](https://github.com/decidim/decidim/releases/tag/v0.27.1)**

## Getting started

1. Clone repository locally

```
git clone git@github.com:OpenSourcePolitics/decidim-cese.git
```

2. Once downloaded, install Ruby dependencies

```
bundle install
```

3. Install Javascript dependencies

```
yarn install
```

4. Setup your database with seeds

```
bundle exec rake db:setup
```

## Running tests

This application has a functional testing suite. You can easily run locally the tests as following :

Create test environment database 

`bundle exec rake test:setup`

And then run tests using `rspec`

`bundle exec rspec spec/`
