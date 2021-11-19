# frozen_string_literal: true

module Bonita
  module Bpm
    class MessageResource < ResourceKit::Resource
      include ErrorHandler

      resources do
        action :send_event do
          path "bonita/API/bpm/message"
          verb :post
          body { |object| object.to_json }
          handler(204) { true }
        end
      end
    end
  end
end
