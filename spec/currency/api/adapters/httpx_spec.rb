# frozen_string_literal: true

require "currency/api/adapters/httpx"

RSpec.describe Currency::Api::Adapters::HTTPX do
  let(:path) { RSpec.configuration.web_server.mount_echo("Hello!") }

  after { RSpec.configuration.web_server.umount(path) }

  describe "#get" do
    subject { described_class.new }

    it "returns response body as a string" do
      expect(subject.get("http://127.0.0.1:3001#{path}")).to eq("Hello!")
    end
  end
end
