gem "awesome_print", comment: "Use Awesome Print for better printing"
gem "devise", comment: "Use Devise for authentication"
gem "mailkick", "~> 1.3.1", comment: "Provide email subscriptions and one-click unsubscribe"
gem "immosquare-cookies", "~> 2.0", comment: "Provide GDPR cookie consent controls"

gem "html2haml", comment: "Use HTML2HAML to convert erb to haml"
gem "haml-rails", "~> 2.0", comment: "Use HAML for HTML templates"

gem "sitemap_generator", comment: "Use sitemap generator to generate sitemaps"

gem "simple_form", comment: "Use Simple Form for forms"

gem "rack-timeout", comment: "Use Rack Timeout to timeout requests"

gem "high_voltage", comment: "Use High Voltage for static pages"

gem "title", comment: "Use Title for dynamic page titles"
gem "view_component", "~> 3.25", comment: "Organize reusable, testable view components"

gem "sidekiq", comment: "Use Sidekiq for background jobs"

gem "rubocop", require: false, comment: "Use Rubocop for linting"
gem "rubocop-rails", require: false, comment: "Use Rubocap Rails for enforcing ruby on rails conventions"

gem "asset_sync", comment: "To upload assets to S3 after precompiling assets"
gem "fog-aws", comment: "To use AWS with asset_sync"

gem_group :development, :test do
  gem "annotate", "~> 3.2", require: false, comment: "Document database columns in models"
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

create_file "compose.yml", <<~YAML
  services:
    mailcatcher:
      image: sj26/mailcatcher:latest
      ports:
        - "1025:1025"
        - "1080:1080"
YAML

environment <<~RUBY, env: "development"
  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { address: "127.0.0.1", port: 1025 }
  config.action_mailer.preview_path = Rails.root.join("spec/mailers/previews")
RUBY

create_file "app/components/application_component.rb", <<~RUBY
  class ApplicationComponent < ViewComponent::Base
  end
RUBY

after_bundle do
  # Convert existing erb files to haml
  run "HAML_RAILS_DELETE_ERB=true rails haml:erb2haml"

  create_file "app/views/shared/_flash.html.haml", <<-CODE
- flash.each do |name, msg|
  - flash_class = case name.to_sym
  - when :success
    - "bg-green-100 border border-green-400 text-green-700"
  - when :error, :alert
    - "bg-red-100 border border-red-400 text-red-700"
  - when :notice, :info
    - "bg-blue-100 border border-blue-400 text-blue-700"
  - when :warning
    - "bg-yellow-100 border border-yellow-400 text-yellow-700"
  - else
    - "bg-gray-100 border border-gray-400 text-gray-700"
  .flash-message{class: flash_class, role: "alert"}
    .container.mx-auto.px-4.py-3.relative
      %p.font-medium= msg
      %button.absolute.top-0.bottom-0.right-0.px-4.py-3{"data-dismiss" => "alert", type: "button"}
        %span.text-2xl &times;
CODE

  insert_into_file "app/views/layouts/application.html.haml", after: "  %body\n" do
    "    = render 'shared/flash'\n    = render \"immosquare-cookies/consent_banner\"\n"
  end

  # Run the simple_form generator
  run "rails generate simple_form:install"
  run "rails generate annotate:install"

  run "rails generate mailkick:install"
  create_file "config/initializers/mailkick.rb", <<~RUBY
    # Add RFC 8058 one-click unsubscribe headers to Mailkick-enabled emails.
    Mailkick.headers = true
  RUBY

  remove_file "app/views/layouts/mailer.html.erb"
  remove_file "app/views/layouts/mailer.text.erb"
  remove_file "app/views/layouts/mailer.html.haml"
  remove_file "app/views/layouts/mailer.text.haml"
  create_file "app/views/layouts/mailer.html.haml", <<~HAML
    !!!
    %html
      %head
        %meta{content: "text/html; charset=UTF-8", "http-equiv": "Content-Type"}
      %body{style: "background:#f6f7f9;margin:0;padding:32px 16px;font-family:Arial,sans-serif;color:#17202a"}
        %table{role: "presentation", width: "100%", cellspacing: "0", cellpadding: "0"}
          %tr
            %td{align: "center"}
              %table{role: "presentation", width: "600", cellspacing: "0", cellpadding: "32", style: "max-width:600px;width:100%;background:#fff;border-radius:8px"}
                %tr
                  %td= yield
  HAML
  create_file "app/views/layouts/mailer.text.haml", <<~HAML
    = yield
  HAML

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
  gsub_file "config/environments/production.rb", /# config\.active_job\.queue_adapter\s+=\s+:resque/, "config.active_job.queue_adapter = :sidekiq"

  #run "bundle exec rails generate devise:install"
  #run "bundle exec generate devise User"

  # Enable Gzip compression
  insert_into_file "config/application.rb", after: "class Application < Rails::Application\n" do
    <<-RUBY
    # Enable Gzip compression for responses
    config.middleware.insert_after ActionDispatch::Static, Rack::Deflater\n
    RUBY
  end

  # Add rack timeout logger configuration
  create_file "config/initializers/rack_timeout.rb", <<-CODE
Rack::Timeout::Logger.disable
CODE

  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
