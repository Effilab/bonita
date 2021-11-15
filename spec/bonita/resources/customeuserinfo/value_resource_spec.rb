# frozen_string_literal: true

RSpec.describe Bonita::Customuserinfo::ValueResource, type: :integration do
  subject { described_class.new(connection: connection) }

  describe "#search" do
    let(:path) { "/bonita/API/customuserinfo/value/1/2" }

    let(:request_body) do
      {value: "foo"}
    end

    before do
      stub_request(connection) do |stub|
        stub.put(path, request_body.to_json) { [200, {}, nil] }
      end
    end

    let(:response) { subject.associate_definition_to_user(userId: 1, definitionId: 2, value: "foo") }

    it "performs the expected request" do
      expect(response).to be true
    end
  end
end
