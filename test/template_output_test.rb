require "minitest/autorun"

class TemplateOutputTest < Minitest::Test
  ROOT = File.expand_path("../blog", __dir__)

  def test_expected_gems
    gemfile = read("Gemfile")

    %w[annotate devise immosquare-cookies mailkick view_component].each do |gem_name|
      assert_includes gemfile, "gem \"#{gem_name}\""
    end
  end

  def test_welcome_page
    assert_file "app/controllers/welcome_controller.rb"
    assert_file "app/views/welcome/index.html.haml"
  end

  def test_application_defaults
    assert_includes read("app/views/layouts/application.html.haml"), "%title= title_tag"
    assert_file "app/views/layouts/mailer.html.haml"
    assert_file "app/components/application_component.rb"
    assert_file ".rubocop.yml"
  end

  def test_admin_dashboard
    assert_file "app/models/admin.rb"
    assert_file "app/controllers/admin/dashboard_controller.rb"
    assert_file "app/views/admin/dashboard/index.html.haml"
  end

  def test_production_healthcheck_silencing
    assert_file "app/middleware/healthcheck_silencer.rb"
    assert_includes read("config/routes.rb"), 'get "/up"'
  end

  private

  def assert_file(relative_path)
    assert File.file?(File.join(ROOT, relative_path)), "Expected #{relative_path} to exist"
  end

  def read(relative_path)
    File.read(File.join(ROOT, relative_path))
  end
end
