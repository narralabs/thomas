gem "awesome_print", comment: "Use Awesome Print for better printing"
gem "devise", comment: "Use Devise for authentication"

gem "html2haml", comment: "Use HTML2HAML to convert erb to haml"
gem "haml-rails", "~> 2.0", comment: "Use HAML for HTML templates"

gem "sitemap_generator", comment: "Use sitemap generator to generate sitemaps"

gem "simple_form", comment: "Use Simple Form for forms"

gem "rack-timeout", comment: "Use Rack Timeout to timeout requests"

gem "high_voltage", comment: "Use High Voltage for static pages"

gem "title", comment: "Use Title for dynamic page titles"

gem "sidekiq", comment: "Use Sidekiq for background jobs"

gem "rubocop", require: false, comment: "Use Rubocop for linting"
gem "rubocop-rails", require: false, comment: "Use Rubocap Rails for enforcing ruby on rails conventions"

gem "asset_sync", comment: "To upload assets to S3 after precompiling assets"
gem "fog-aws", comment: "To use AWS with asset_sync"

gem_group :development, :test do
  gem "rspec-rails", '~> 6.1.0', comment: "Use RSpec for testing"
  gem "factory_bot_rails", comment: "Use Factory Bot for fixtures"
  gem "timecop", comment: "Use Timecop for time testing"
end

gem_group :test do
  gem 'shoulda-matchers', '~> 6.0', comment: "Use Shoulda Matchers for test matchers"
end

route "root to: 'welcome#index'"
create_file "app/controllers/welcome_controller.rb", <<-CODE
class WelcomeController < ApplicationController
  def index
  end
end
CODE
create_file "app/views/welcome/index.html.haml", <<-CODE
%h1 Hello World from Thomas
CODE

after_bundle do
  # Convert existing erb files to haml
  run "HAML_RAILS_DELETE_ERB=true rails haml:erb2haml"

  # Run the simple_form generator
  run "rails generate simple_form:install"

  # Run the rspec generator and remove the test directory
  run "rails generate rspec:install"
  run "rm -rf test"

  # Add shoulda-matchers config to the bottom of spec/rails_helper.rb
  append_to_file "spec/rails_helper.rb", <<-STR
\nShoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
STR

  # Add sidekiq production config
  gsub_file "config/environments/production.rb", /# config.active_job.queue_adapter = :resque/, "config.active_job.queue_adapter = :sidekiq"

  # Add rubocop config file
  file ".rubocop.yml", <<-CODE
require: rubocop-rails

Style/StringLiterals:
  EnforcedStyle: double_quotes
  SupportedStyles:
    - single_quotes
    - double_quotes
CODE

  #run "bundle exec rails generate devise:install"
  #run "bundle exec generate devise User"

  # Enable Gzip compression
  insert_into_file "config/application.rb", after: "class Application < Rails::Application\n" do
    <<-RUBY
    # Enable Gzip compression for responses
    config.middleware.insert_after ActionDispatch::Static, Rack::Deflater\n
    RUBY
  end

  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
