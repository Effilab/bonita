# frozen_string_literal: true

module Bonita::ErrorHandler
  def self.included(base)
    base.send(:resources) do
      default_handler do |response|
        next if (200...299).cover?(response.status)

        case response.status
        when 401
          if response.respond_to?(:reason_phrase)
            raise Bonita::UnauthorizedError, response.reason_phrase
          else
            raise Bonita::AuthError
          end
        when 404
          raise Bonita::RecordNotFoundError
        else
          raise Bonita::Error.new(response.status, response.body, response.env.url)
        end
      end
    end
  end
end
