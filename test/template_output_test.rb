require "minitest/autorun"

class TemplateOutputTest < Minitest::Test
  ROOT = File.expand_path("../blog", __dir__)

  def test_expected_gems
    gemfile = read("Gemfile")

    %w[
      annotaterb
      devise
      haml-rails
      immosquare-cookies
      mailkick
      rack-timeout
      rspec-rails
      rubocop-rails
      sidekiq
      simple_form
      view_component
    ].each do |gem_name|
      assert_includes gemfile, "gem \"#{gem_name}\""
    end
  end

  def test_welcome_page
    assert_file "app/controllers/welcome_controller.rb"
    assert_file "app/views/welcome/index.html.haml"
  end

  def test_production_defaults
    production = read("config/environments/production.rb")

    assert_includes production, "config.active_job.queue_adapter = :sidekiq"
    assert_file "config/initializers/rack_timeout.rb"
  end

  def test_mail_defaults
    development = read("config/environments/development.rb")

    assert_includes development, "config.action_mailer.delivery_method = :smtp"
    assert_includes development, 'config.action_mailer.preview_path = Rails.root.join("spec/mailers/previews")'
    assert_includes read("config/initializers/mailkick.rb"), "Mailkick.headers = true"
    assert_file "app/views/layouts/mailer.html.haml"
    assert_file "app/views/layouts/mailer.text.haml"
    assert_file "compose.yml"
  end

  def test_admin_and_application_defaults
    assert_file "app/models/admin.rb"
    assert_file "app/controllers/admin/dashboard_controller.rb"
    assert_file "app/components/application_component.rb"
    assert_file "app/middleware/healthcheck_silencer.rb"

    layout = read("app/views/layouts/application.html.haml")
    assert_includes layout, "%title= title_tag"
    assert_includes layout, 'render "immosquare-cookies/consent_banner"'
  end

  private

  def assert_file(relative_path)
    assert File.file?(File.join(ROOT, relative_path)), "Expected #{relative_path} to exist"
  end

  def read(relative_path)
    File.read(File.join(ROOT, relative_path))
  end
end
