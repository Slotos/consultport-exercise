# frozen_string_literal: true

RSpec.describe Currency::Converter do
  it "has a version number" do
    expect(Currency::Converter::VERSION).not_to be nil
  end

  describe ".new" do
    let(:remote_client) do
      double("client")
    end

    it "expects remote client to implement #fetch" do
      expect { described_class.new(client: remote_client) }.to raise_error(described_class::IncompatibleClient)
      allow(remote_client).to receive(:fetch)
      expect { described_class.new(client: remote_client) }.not_to raise_error
    end
  end

  describe "#convert" do
    subject { described_class.new(client: remote_client) }

    let(:remote_client) { double("client", fetch: conversion_rates) }

    context "when conversion is known" do
      let(:conversion_rates) { {usd: 3, pln: 2.3412} }

      it "correctly converts the amount" do
        amount = 32
        expect(subject.convert(amount, from: "JPY", to: "PLN")).to eq(BigDecimal(amount) * conversion_rates[:pln])
      end
    end

    context "when conversion is not known" do
      let(:conversion_rates) { {usd: 3, pln: 2.3412} }

      it "raises error" do
        amount = 32
        expect { subject.convert(amount, from: "JPY", to: "BYN") }.to raise_error(described_class::UnknownRate).with_message("Couldn't discover conversion rate from JPY to BYN")
      end
    end
  end
end
