# frozen_string_literal: true

RSpec.describe Bonita::Customuserinfo::UserResource, type: :integration do
  subject { described_class.new(connection: connection) }

  describe "#search" do
    let(:path) { "/bonita/API/customuserinfo/user?c=2&f=userId%3D1&p=2" }

    let(:response_body) do
      [
        {
          userId: "1",
          value: "green",
          definitionId: {
            id: "1",
            description: "the favorite color of the user",
            name: "favorite_color"
          }
        },
        {
          userId: "1",
          value: 26,
          definitionId: {
            id: "2",
            description: "how old is the user",
            name: "age"
          }
        }
      ]
    end

    let(:connection) do
      build_connection do |stub|
        stub.get(path) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) { subject.search(c: 2, p: 2, f: "userId=1") }

    it "performs the expected request" do
      expect(response.first).to eq(
        Bonita::Customuserinfo::UserMapping.extract_single(response_body.first.to_json, :read)
      )
      expect(response.last).to eq(
        Bonita::Customuserinfo::UserMapping.extract_single(response_body.last.to_json, :read)
      )
    end

    it "maps nested keys to existing model objects" do
      expect(response.first.definitionId).to eq(
        Bonita::Customuserinfo::Definition.new(response_body.first[:definitionId])
      )
    end
  end
end
