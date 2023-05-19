# frozen_string_literal: true

require "currency/converter"
require "webrick"
require "securerandom"

class TestServer
  include Singleton

  def initialize
    @server = ::WEBrick::HTTPServer.new(
      BindAddress: "127.0.0.1",
      Port: 3001,
      StartCallback: -> { @started = true }
    )

    Thread.new { @server.start }
    Timeout.timeout(1) { :wait until @started }
  end

  def mount_echo(echo, suffix: "")
    Pathname("/#{SecureRandom.uuid}")
      .tap do |path|
        @server.mount_proc((path + suffix.to_s).to_s) do |request, response|
          response.body = echo
        end
      end
  end

  def umount(path, suffix: "")
    @server.umount((Pathname(path) + suffix.to_s).to_s)
  end

  def shutdown
    @server.shutdown
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.add_setting :web_server
  config.web_server = TestServer.instance
  config.after(:suite) { config.web_server.shutdown }
end
