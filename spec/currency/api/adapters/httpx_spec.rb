# frozen_string_literal: true

require "currency/api/adapters/httpx"
require "webrick"

RSpec.describe Currency::Api::Adapters::HTTPX do
  around(:all) do |all|
    @started = false
    @server = ::WEBrick::HTTPServer.new(
      BindAddress: "127.0.0.1",
      Port: 3001,
      StartCallback: -> { @started = true }
    )

    @server.mount_proc("/") do |request, response|
      response.body = "Hello!"
    end

    Thread.new { @server.start }
    Timeout.timeout(1) { :wait until @started }

    all.run
  ensure
    @server.shutdown
  end

  describe "#get" do
    subject { described_class.new }

    it "returns response body as a string" do
      expect(subject.get("http://127.0.0.1:3001/")).to eq("Hello!")
    end
  end
end
