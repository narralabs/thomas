require "minitest/autorun"
require "open3"

class BundleInstallTest < Minitest::Test
  ROOT = File.expand_path("../blog", __dir__)

  def test_generated_application_bundle_installs
    lockfile = File.join(ROOT, "Gemfile.lock")
    File.delete(lockfile) if File.exist?(lockfile)

    output, status = Open3.capture2e("bundle", "install", chdir: ROOT)

    assert status.success?, "bundle install failed for the generated application:\n#{output}"
    assert File.exist?(lockfile), "bundle install did not produce Gemfile.lock"
  end
end
