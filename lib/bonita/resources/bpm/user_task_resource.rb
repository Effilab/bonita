# frozen_string_literal: true

module Bonita
  module Bpm
    class UserTaskResource < ResourceKit::Resource
      include ErrorHandler

      resources do
        action :find do
          path "bonita/API/bpm/userTask/:userTaskId"
          verb :get
          query_keys :d
          handler(200) { |response| UserTaskMapping.extract_single(response.body, :read) }
        end

        action :context do
          path "bonita/API/bpm/userTask/:userTaskId/context"
          verb :get
          handler(200) { |response| JSON.parse(response.body, symbolize_names: true) }
        end

        # Needs real life testing
        action :update do
          path "bonita/API/bpm/userTask/:userTaskId"
          verb :put
          body { |object| Bonita::Utils::UpdateHandler.new(object, UserTaskMapping).call }
          handler(200) { true }
        end

        # Needs real life testing
        action :execution do
          path "bonita/API/bpm/userTask/:userTaskId/execution"
          verb :post
          # Raises ArgumentError "no receiver given" error if the rule is applied
          body { |object| object.to_json }
          handler(200) { |response| JSON.parse(response.body, symbolize_names: true) }
        end
      end
    end
  end
end
