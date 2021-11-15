# frozen_string_literal: true

module Bonita
  class Error < StandardError
    attr_reader :java_exception, :error_message, :explanations, :status

    def initialize(status, body, request_url)
      if body["exception"]
        mapping = Bonita::ErrorMapping.extract_single(body, :read)
        @java_exception = mapping.exception
        @error_message = mapping.message
        @explanations = mapping.explanations
        @status = status
        @request_url = request_url
        values = instance_variables.map { |name| [name, instance_variable_get(name)] }.to_h
      else
        values = body
      end

      super(values)
    end
  end

  AuthError = Class.new(StandardError)
  ForbiddenError = Class.new(StandardError)
  RecordNotFoundError = Class.new(StandardError)
  UnauthorizedError = Class.new(StandardError)
end
