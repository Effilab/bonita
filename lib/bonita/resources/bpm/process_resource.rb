# frozen_string_literal: true

module Bonita
  module Bpm
    # API reference : http://documentation.bonitasoft.com/?page=bpm-api#toc27
    class ProcessResource < ResourceKit::Resource
      include ErrorHandler

      resources do
        action :find do
          path "bonita/API/bpm/process/:processId"
          verb :get
          handler(200) { |response| ProcessMapping.extract_single(response.body, :read) }
        end

        action :search do
          query_keys :c, :d, :f, :o, :p, :s
          path "bonita/API/bpm/process"
          verb :get
          handler(200) { |response| ProcessMapping.extract_collection(response.body, :read) }
        end

        action :instantiate do
          path "bonita/API/bpm/process/:processId/instantiation"
          verb :post
          # Raises ArgumentError "no receiver given" error if the rule is applied
          body { |object| object.to_json }
          handler(200) { |response| JSON.parse(response.body, symbolize_names: true) }
        end

        action :update do
          path "bonita/API/bpm/process/:processId"
          verb :put
          body { |object| Bonita::Utils::UpdateHandler.new(object, ProcessMapping).call }
          handler(200) { |response| ProcessMapping.extract_single(response.body, :read) }
        end
      end
    end
  end
end
