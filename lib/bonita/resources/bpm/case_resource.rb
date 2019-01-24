# frozen_string_literal: true

module Bonita
  module Bpm
    # API reference : http://documentation.bonitasoft.com/?page=bpm-api#toc27
    class CaseResource < ResourceKit::Resource
      include ErrorHandler

      resources do
        action :find do
          path "bonita/API/bpm/case/:caseId"
          verb :get
          query_keys :d, :n
          handler(200) { |response| CaseMapping.extract_single(response.body, :read) }
        end

        action :create do
          path "bonita/API/bpm/case/"
          verb :post
          body { |object| CaseMapping.safe_representation_for(:create, object) }
          handler(200) { |response| CaseMapping.extract_single(response.body, :read) }
        end

        action :search do
          query_keys :s, :f, :o, :d, :c
          path "bonita/API/bpm/case"
          verb :get
          handler(200) { |response, payload| Bonita::Utils::SearchHandler.new(response, payload, self).call }
        end

        action :delete do
          path "bonita/API/bpm/case/:caseId"
          verb :delete
          handler(200) { true }
        end

        action :delete_bulk do
          path "bonita/API/bpm/case/"
          verb :delete
          body(&:to_json)
          handler(200) { true }
        end

        action :context do
          path "bonita/API/bpm/case/:caseId/context"
          verb :get
          handler(200) { |response| CaseMapping.extract_single(response.body, :read) }
        end
      end
    end
  end
end
