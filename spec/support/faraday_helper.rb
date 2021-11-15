# frozen_string_literal: true

module Bonita::FaradayHelper
  extend RSpec::SharedContext

  let(:connection_options) do
    {
      url: "http://test-suite.com",
      request: {
        params_encoder: Faraday::FlatParamsEncoder
      },
      headers: {
        content_type: "application/json"
      }
    }
  end

  def build_connection(&block)
    Faraday.new(connection_options) do |conn|
      conn.use Faraday::Request::UrlEncoded
      conn.adapter :test do |stubs|
        # stubs.strict_mode = true
        block.call(stubs)
      end
    end
  end
end
