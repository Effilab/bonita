# frozen_string_literal: true

RSpec.describe Bonita::Customuserinfo::DefinitionResource, type: :integration do
  subject { described_class.new(connection: connection) }

  describe "#find" do
    let(:path) { "bonita/API/customuserinfo/definition?c=2&p=2" }

    let(:response_body) do
      [
        {
          id: "_id of definition_",
          description: "_definition description_",
          name: "_definition name_"
        },
        {
          id: "_id of definition_",
          description: "_definition description_",
          name: "_definition name_"
        }
      ]
    end

    let(:connection) do
      build_connection do |stub|
        stub.get(path) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) { subject.all(c: 2, p: 2) }

    it "performs the expected request" do
      expect(response.first).to eq Bonita::Customuserinfo::Definition.new(response_body.first)
      expect(response.last).to eq Bonita::Customuserinfo::Definition.new(response_body.last)
    end
  end

  describe "#create" do
    let(:path) do
      "bonita/API/customuserinfo/definition"
    end

    let(:request_body) do
      {
        name: "new definition",
        description: "a description"
      }
    end

    let(:response_body) do
      {
        id: 1,
        name: "new definition",
        description: "a description"
      }
    end

    let(:connection) do
      build_connection do |stub|
        stub.post(path) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) do
      subject.create(Bonita::Customuserinfo::Definition.new(request_body))
    end

    it "performs the expected request" do
      expect(response).to eq Bonita::Customuserinfo::Definition.new(response_body)
    end
  end

  describe "#delete" do
    let(:path) { "bonita/API/customuserinfo/definition/1" }

    let(:connection) do
      build_connection do |stub|
        stub.delete(path) { [200, {}, nil] }
      end
    end

    let(:response) { subject.delete(definitionId: 1) }

    it "performs the expected request" do
      expect(response).to be true
    end
  end
end
