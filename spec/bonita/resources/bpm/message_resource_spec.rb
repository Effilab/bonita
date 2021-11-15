# frozen_string_literal: true

RSpec.describe Bonita::Bpm::MessageResource, type: :integration do
  subject { described_class.new(connection: connection) }

  describe "#send_event" do
    let(:path) { "bonita/API/bpm/message" }

    let(:request_body) do
      {
        messageName: "myMessage",
        targetProcess: "processName",
        targetFlowNode: "catchMessageFlowNodeName",
        messageContent: {
          data1: {
            value: "aValue"
          },
          data2: {
            value: 42,
            type: "java.lang.Long"
          }
        },
        correlations: {
          key1: {
            value: "aValue"
          },
          key2: {
            value: 123,
            type: "java.lang.Integer"
          }
        }
      }
    end

    let(:response_body) do
      ""
    end

    let(:connection) do
      build_connection do |stub|
        stub.post(path, request_body.to_json) { [204, {}, response_body.to_json] }
      end
    end

    let(:response) { subject.send_event(request_body, processId: 1) }

    it "performs the expected request" do
      expect(response).to be true
    end
  end
end
