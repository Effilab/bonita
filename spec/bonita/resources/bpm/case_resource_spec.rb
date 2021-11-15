# frozen_string_literal: true

RSpec.describe Bonita::Bpm::CaseResource, type: :integration do
  subject { described_class.new(connection: connection) }

  describe "#find" do
    let(:path) { "bonita/API/bpm/case/1" }

    let(:body) do
      {
        id: "the identifier of the case",
        end_date: "the date set when the case is closed",
        failedFlowNodes: "count of failed flow nodes if parameter n=failedFlowNodes is given",
        startedBySubstitute: "the identifier of the substitute user",
        start: "the starting date of the case",
        activeFlowNodes: "count of active flow nodes if parameter n=activeFlowNodes is given",
        state: "state: an enum that represent the state of the case",
        rootCaseId: "the identifier of the container of the case",
        started_by: "the identifier of the user who started the case",
        processDefinitionId: "the identifier of the process related of the case",
        last_update_date: "the date of the last update done on the case",
        searchIndex1Label: "the 1st search index label (from 6.5, in Subscription editions only)",
        searchIndex2Label: "the 2nd search index label (from 6.5, in Subscription editions only)",
        searchIndex3Label: "the 3rd search index label (from 6.5, in Subscription editions only)",
        searchIndex4Label: "the 4th search index label (from 6.5, in Subscription editions only)",
        searchIndex5Label: "the 5th search index label (from 6.5, in Subscription editions only)",
        searchIndex1Value: "the 1st search index value (from 6.5, in Subscription editions only)",
        searchIndex2Value: "the 2nd search index value (from 6.5, in Subscription editions only)",
        searchIndex3Value: "the 3rd search index value (from 6.5, in Subscription editions only)",
        searchIndex4Value: "the 4th search index value (from 6.5, in Subscription editions only)",
        searchIndex5Value: "the 5th search index value (from 6.5, in Subscription editions only)"
      }
    end

    let(:connection) do
      build_connection do |stub|
        stub.get(path) { [200, {}, body.to_json] }
      end
    end

    let(:response) { subject.find(caseId: 1) }

    it "returns a properly set Bonita::Bpm::Case instance" do
      expect(response).to eq Bonita::Bpm::Case.new(body)
    end
  end

  describe "#create" do
    let(:path) { "bonita/API/bpm/case" }

    let(:request_body) do
      {
        processDefinitionId: "5777042023671752656",
        variables: [
          {
            name: "stringVariable",
            value: "aValue"
          },
          {
            name: "dateVariable",
            value: 349_246_800_000
          },
          {
            name: "numericVariable",
            value: 5
          }
        ]
      }
    end

    let(:response_body) do
      {
        id: "1001",
        end_date: "",
        startedBySubstitute: "4",
        start: "2014-12-01 14:36:23.732",
        state: "started",
        rootCaseId: "1001",
        started_by: "4",
        processDefinitionId: "5777042023671752656",
        last_update_date: "2014-12-01 14:36:23.732"
      }
    end

    let(:connection) do
      build_connection do |stub|
        stub.post(path, request_body.to_json) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) { subject.create(Bonita::Bpm::Case.new(request_body)) }

    it "performs the expected request" do
      expect(response).to eq Bonita::Bpm::Case.new(response_body)
    end
  end

  describe "#search" do
    let(:path) do
      "bonita/API/bpm/case"
    end

    let(:response_body) do
      [
        { id: "foo" },
        { id: "bar" }
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
        d: %w[processDefinitionId started_by startedBySubstitute],
        o: "name",
        s: "foo",
        f: "activationState=DISABLED"
      )
    end

    it "performs the expected request" do
      expect(response).to all be_a Bonita::Bpm::Case
    end
  end

  describe "#delete" do
    let(:path) { "bonita/API/bpm/case/1" }

    let(:connection) do
      build_connection do |stub|
        stub.delete(path) { [200, {}, nil] }
      end
    end

    let(:response) do
      subject.delete(caseId: 1)
    end

    it "performs the expected request" do
      expect(response).to be true
    end
  end

  describe "#delete_bulk", skip: "cannot stub DELETE request with body" do
    let(:path) { "bonita/API/bpm/case" }
    let(:request_body) do
      %w[1 2 3 4 5]
    end

    let(:connection) do
      build_connection do |stub|
        stub.delete(path) { [200, {}, nil] }
      end
    end

    let(:response) do
      subject.delete_bulk(request_body)
    end

    it "performs the expected request" do
      expect(response).to be true
    end
  end

  describe "#context" do
    let(:path) { "bonita/API/bpm/case/1/context" }

    let(:response_body) do
      { foo: "bar" }
    end

    let(:connection) do
      build_connection do |stub|
        stub.get(path) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) do
      subject.context(caseId: 1)
    end

    it "performs the expected request" do
      expect(response).to eq response_body
    end
  end
end
