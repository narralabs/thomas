require "json"
require "minitest/autorun"
require "net/http"
require "open3"
require "socket"
require "timeout"

class GeneratedAppTest < Minitest::Test
  ROOT = File.expand_path("../blog", __dir__)

  class << self
    attr_accessor :server_pid, :server_log, :server_port
  end

  def self.run!(*command, env: {})
    stdout, status = Open3.capture2e(env, *command, chdir: ROOT)
    raise "#{command.join(" ")} failed:\n#{stdout}" unless status.success?

    stdout
  end

  def self.wait_for_http(uri, timeout: 30)
    Timeout.timeout(timeout) do
      loop do
        response = Net::HTTP.get_response(uri)
        return response if response
      rescue Errno::ECONNREFUSED, Errno::ECONNRESET, EOFError, Net::OpenTimeout, Net::ReadTimeout
        sleep 0.25
      end
    end
  end

  def self.start_server
    socket = TCPServer.new("127.0.0.1", 0)
    self.server_port = socket.addr[1]
    socket.close

    self.server_log = File.open(File.join(ROOT, "tmp/ci-server.log"), "w")
    self.server_pid = Process.spawn(
      { "RAILS_ENV" => "test" },
      "bin/rails", "server", "--binding", "127.0.0.1", "--port", server_port.to_s,
      chdir: ROOT,
      out: server_log,
      err: server_log
    )
    wait_for_http(URI("http://127.0.0.1:#{server_port}/up"))
  rescue StandardError
    server_log&.flush
    warn File.read(server_log.path) if server_log
    raise
  end

  def self.stop_server
    return unless server_pid

    Process.kill("TERM", server_pid)
    Process.wait(server_pid)
  rescue Errno::ESRCH, Errno::ECHILD
    nil
  ensure
    server_log&.close
  end

  def self.prepare
    run!("bin/rails", "db:prepare", env: { "RAILS_ENV" => "test" })
    run!("bin/rails", "db:prepare", env: { "RAILS_ENV" => "development" })
    run!("bundle", "exec", "rspec")
    run!("bundle", "exec", "rubocop", "--show-cops", "Style/StringLiterals")

    mailcatcher = wait_for_http(URI("http://127.0.0.1:1080/messages"))
    raise "Mailcatcher is unavailable" unless mailcatcher.is_a?(Net::HTTPSuccess)

    run!("bin/rails", "runner", File.expand_path("support/mail_smoke.rb", __dir__), env: { "RAILS_ENV" => "development" })
    messages = JSON.parse(Net::HTTP.get(URI("http://127.0.0.1:1080/messages")))
    raise "Mailcatcher did not receive the smoke-test email" unless messages.any? { |message| message["subject"] == "Thomas CI mail smoke test" }

    start_server
  end

  prepare
  Minitest.after_run { stop_server }

  def request(path)
    Net::HTTP.get_response(URI("http://127.0.0.1:#{self.class.server_port}#{path}"))
  end

  def test_home_page_renders_template_defaults
    response = request("/")

    assert_instance_of Net::HTTPOK, response
    assert_includes response.body, "Hello World from Thomas"
    assert_includes response.body, "<title>Blog</title>"
    assert_match(/cookie|consent/i, response.body)
  end

  def test_healthcheck
    response = request("/up")

    assert_instance_of Net::HTTPOK, response
    assert_equal "OK", response.body
  end

  def test_admin_dashboard_requires_authentication
    response = request("/admin")

    assert_instance_of Net::HTTPFound, response
    assert_includes response.fetch("location"), "/admins/sign_in"
  end
end
