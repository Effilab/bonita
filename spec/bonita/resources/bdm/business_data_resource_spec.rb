# frozen_string_literal: true

RSpec.describe Bonita::Bdm::BusinessDataResource, type: :integration do
  subject { described_class.new(connection: connection) }

  describe "#find" do
    let(:path) { "/bonita/API/bdm/businessData/com.company.model.Contract/1" }

    let(:response_body) do
      { foo: "bar" }
    end

    let(:connection) do
      build_connection do |stub|
        stub.get(path) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) { subject.find(businessDataType: "com.company.model.Contract", persistenceId: 1) }

    it "performs the expected request" do
      expect(response).to eq response_body
    end
  end

  describe "#search" do
    let(:path) do
      "/bonita/API/bdm/businessData/com.company.model.Employee" # rubocop:disable Metrics/LineLength
    end

    let(:response_body) do
      [
        {
          firstname: "John",
          lastname: "Doe"
        }
      ]
    end

    let(:connection) do
      build_connection do |stub|
        stub.get(path) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) do
      subject.search(
        businessDataType: "com.company.model.Employee",
        c: 10,
        f: %w[firstName=John lastname=Doe],
        p: 0,
        q: "findEmployeeByFirstNameAndLastName"
      )
    end

    it "performs the expected request" do
      expect(response.first).to eq(response_body.first)
    end
  end
end
