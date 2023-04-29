# frozen_string_literal: true

require "json"

module Currency
  module Api
    class Exchangerate
      URL = "https://open.er-api.com/v6/latest/"

      # @param [#get] adapter An adapter that can return raw data from data source given a URL
      # @param [String, URI] a URL to use, defaults to open API endpoint
      def initialize(adapter, url: URL)
        @adapter = adapter
        @url = url
      end

      def fetch(currency)
        JSON
          .parse(@adapter.get(@url + currency.to_s.upcase))
          .fetch("rates", {})
          .transform_keys(&:downcase)
      end
    end
  end
end
