# frozen_string_literal: true

require "httpx"

module Currency
  module Api
    module Adapters
      class HTTPX
        def get(url)
          ::HTTPX.get(url).to_s
        end
      end
    end
  end
end
