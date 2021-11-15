# frozen_string_literal: true

module Bonita
  module Identity
    # API reference : http://documentation.bonitasoft.com/?page=bpm-api#toc36
    class UserResource < ResourceKit::Resource
      include ErrorHandler

      resources do
        action :read do
          path "bonita/API/identity/user/:userId"
          query_keys :d
          verb :get
          handler(200) { |response| Bonita::Identity::User.new(JSON.parse(response.body, symbolize_names: true)) }
        end

        action :search do
          query_keys :c, :d, :f, :o, :p, :s
          path "bonita/API/identity/user"
          verb :get
          handler(200) do |response|
            JSON.parse(response.body, symbolize_names: true).map { |i| Bonita::Identity::User.new(i) }
          end
        end

        action :create do
          path "bonita/API/identity/user"
          verb :post
          body { |object| UserMapping.safe_representation_for(:create, object) }
          handler(200) { |response| Bonita::Identity::User.new(JSON.parse(response.body, symbolize_names: true)) }
        end

        action :update do
          path "bonita/API/identity/user/:userId"
          verb :put
          body { |object| Bonita::Utils::UpdateHandler.new(object, UserMapping).call }
          handler(200) { true }
        end

        action :delete do
          path "bonita/API/identity/user/:userId"
          verb :delete
          handler(200) { true }
        end

        action :enable do
          path "bonita/API/identity/user/:userId"
          verb :put
          body { {enabled: "true"}.to_json }
          handler(200) { true }
        end

        action :disable do
          path "bonita/API/identity/user/:userId"
          verb :put
          body { {enabled: "false"}.to_json }
          handler(200) { true }
        end
      end
    end
  end
end
