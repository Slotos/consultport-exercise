# frozen_string_literal: true

require_relative "converter/version"
require "bigdecimal"

module Currency
  class Converter
    class IncompatibleClient < StandardError; end

    class UnknownRate < StandardError; end

    # @param [#fetch] client A client that can fetch conversion rates for a provided currency
    def initialize(client:, precision: 6)
      raise IncompatibleClient unless client.respond_to?(:fetch)

      @client = client
      @precision = precision
    end

    # @param [String,Integer,Float,BigDecimal] amount A value to convert from. Expected to be parseable by BigDecimal interface
    # @param [String,Symbol] from An ISO 4217 currency code to convert from
    # @param [String,Symbol] from An ISO 4217 currency code to convert to
    # @return [BigDecimal] the amount in a new currency
    def convert(amount, from:, to:)
      amount * BigDecimal(conversion_rate(from: from.to_s, to: to.to_s), @precision)
    end

    private

    def conversion_rate(from:, to:)
      @client.fetch(from.downcase.to_sym).fetch(to.downcase.to_sym, nil) ||
        raise(UnknownRate, "Couldn't discover conversion rate from #{from.upcase} to #{to.upcase}")
    end
  end
end
