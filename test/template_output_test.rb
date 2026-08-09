require "minitest/autorun"

class TemplateOutputTest < Minitest::Test
  ROOT = File.expand_path("../blog", __dir__)

  def test_expected_gems
    gemfile = read("Gemfile")

    %w[haml-rails rspec-rails simple_form].each do |gem_name|
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

  private

  def assert_file(relative_path)
    assert File.file?(File.join(ROOT, relative_path)), "Expected #{relative_path} to exist"
  end

  def read(relative_path)
    File.read(File.join(ROOT, relative_path))
  end
end
