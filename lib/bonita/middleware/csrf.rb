# frozen_string_literal: true

module Bonita
  module Middleware
    class CSRF
      def initialize(app, options = {})
        @app = app
        @options = options
      end

      def call(env)
        if env[:request_headers]["Cookie"]
          token = /X-Bonita-API-Token=([a-f0-9\-]+)/.match(env[:request_headers]["Cookie"])&.captures&.first
          env[:request_headers]["X-Bonita-API-Token"] = token if token
        end
        @app.call(env)
      end
    end
  end
end
