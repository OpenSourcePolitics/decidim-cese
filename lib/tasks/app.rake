# frozen_string_literal: true

namespace :app do
  desc "Upgrade the base code of the Decidim-app"
  task upgrade: :environment do
    puts "----- Upgrading base code of Decidim-app ------"
    raise "You must provide env var 'DECIDIM_BRANCH' for using this rake task" unless decidim_version == ENV.fetch("DECIDIM_BRANCH", nil)

    upgrader = Upgrader.new decidim_version

    upgrader.fetch_ruby_version!
    upgrader.fetch_node_version!
    upgrader.fetch_erblint!
    # upgrader.update_rubocop!
    upgrader.rewrite_gemfile!
    upgrader.overloads

    puts "Files updated on '#{upgrader.version}'"
    puts "----------- Next steps (manually) --------------"
    puts "1. Check overrides for extends
  See in lib/extends/**/*.rb"
    puts "2. Run
  $ bundle install"
    puts "3. Upgrade Decidim
  $ bundle exec rake decidim:upgrade"
    puts "4. Install Yarn dependencies
  $ yarn install"
    puts "5. Apply migrations
  $ bundle exec rake db:migrate"
    puts "6. Run locally the application
  $ bundle exec rails s"
  end
end

class Upgrader
  attr_accessor :version

  def initialize(gh_branch, _quiet: false)
    @version = gh_branch
    @quiet = false
    @repository_url = "https://raw.githubusercontent.com/decidim/decidim/#{@version}/"
  end

  def fetch_ruby_version!
    fetch_and_save! ".ruby-version"
  end

  def fetch_node_version!
    fetch_and_save! ".node-version"
  end

  def fetch_erblint!
    fetch_and_save! ".erb-lint.yml"
  end

  def update_rubocop!
    puts "Fetching and saving file '.rubocop.yml'..." unless @quiet

    rubocop = YAML.load_file(".rubocop.yml")
    rubocop["inherit_from"] = "#{@repository_url}.rubocop.yml"

    File.write(".rubocop.yml", rubocop.to_yaml)
  end

  def rewrite_gemfile!
    puts "Preparing Gemfile..." unless @quiet
    in_block = false

    file_contents = File.readlines("Gemfile").map do |line|
      line = "DECIDIM_VERSION = \"#{@version}\"\n" if line.include?("DECIDIM_VERSION =")

      in_block = false if line.include?("## End")

      line = "# #{line}" if in_block && !line.start_with?("#")

      in_block = true if line.include?("## Block")

      line
    end

    File.write("Gemfile", file_contents.join)
    puts "Gemfile updated!" unless @quiet
    compare_gemfiles
  end

  def overloads
    YAML.load_file(".overloads.yml").each do |key, value|
      value.each do |path|
        File.write(path, get("decidim-#{key}/#{path}"))
      end
    end
  end

  private

  def compare_gemfiles
    puts "/!\ You must know compare manually the original Gemfile and the Decidim-app Gemfile"
    puts "Please update the dependencies versions according to the following Gemfile"
    sleep 3

    new = get("Gemfile")
    new.split("\n").each { |line| puts line }

    puts "Done ? (Type Enter)"
    $stdin.gets.to_s.strip
  end

  def fetch_and_save!(filename)
    puts "Fetching and saving file '#{filename}'..." unless @quiet

    content = get(filename)
    store!(filename, content)
  end

  def store!(filename, content)
    File.write(filename, content)
  end

  def get(file)
    curl("#{@repository_url}#{file}")
  end

  def curl(uri)
    response = Faraday.get(uri)
    response.body
  end
end
