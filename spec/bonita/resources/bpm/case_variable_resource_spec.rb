# frozen_string_literal: true

RSpec.describe Bonita::Bpm::CaseVariableResource, type: :integration do
  subject { described_class.new(connection: connection) }

  describe "#find" do
    let(:path) { "bonita/API/bpm/caseVariable/1/var" }

    let(:response_body) do
      {
        description: "Detailed description of the case variable, as set in the definition at design-time",
        name: "name of the variable in the case",
        value: "the current value of the case variable",
        case_id: "ID of the case this variable belongs to",
        type: "the Java type of the variable"
      }
    end

    let(:connection) do
      build_connection do |stub|
        stub.get(path) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) { subject.find(caseId: 1, variableName: "var") }

    it "performs the expected request" do
      expect(response).to eq Bonita::Bpm::CaseVariable.new(response_body)
    end
  end

  describe "#update" do
    let(:path) { "bonita/API/bpm/caseVariable/1/var" }

    let(:request_body) do
      {
        type: "String",
        value: "foo"
      }
    end

    let(:response_body) do
      {
        description: "Detailed description of the case variable, as set in the definition at design-time",
        name: "name of the variable in the case",
        value: "foo",
        case_id: "ID of the case this variable belongs to",
        type: "String"
      }
    end

    let(:connection) do
      build_connection do |stub|
        stub.put(path, request_body.to_json) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) { subject.update(Bonita::Bpm::CaseVariable.new(request_body), caseId: 1, variableName: "var") }

    it "performs the expected request" do
      expect(response).to be true
    end
  end

  describe "#search" do
    let(:path) do
      "bonita/API/bpm/caseVariable?c=3&p=2&f=case_id=123"
    end

    let(:response_body) do
      [
        {name: "foo"},
        {name: "bar"}
      ]
    end

    let(:connection) do
      build_connection do |stub|
        stub.get(path) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) do
      subject.search(
        c: 3,
        p: 2,
        f: "case_id=123"
      )
    end

    it "performs the expected request" do
      expect(response).to all be_a Bonita::Bpm::CaseVariable
    end
  end
end
