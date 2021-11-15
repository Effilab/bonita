# frozen_string_literal: true

RSpec.describe Bonita::Bpm::ProcessResource, type: :integration do
  subject { described_class.new(connection: connection) }

  describe "#find" do
    let(:path) { "bonita/API/bpm/process/1" }

    let(:response_body) do
      {
        id: "1",
        icon: "/default/process.png",
        displayDescription: "process description",
        deploymentDate: "2015-01-02 14:21:18.421",
        description: "another process description",
        activationState: "ENABLED",
        name: "Pool1",
        deployedBy: "2",
        displayName: "Pool1",
        actorinitiatorid: "2",
        last_update_date: "2015-01-02 14:21:18.529",
        configurationState: "RESOLVED",
        version: "1.0"
      }
    end

    let(:connection) do
      build_connection do |stub|
        stub.get(path) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) { subject.find(processId: 1) }

    it "performs the expected request" do
      expect(response).to eq Bonita::Bpm::Process.new(response_body)
    end
  end

  describe "#search" do
    let(:path) do
      "bonita/API/bpm/process?c=3&p=2&o=name&d=deployedBy&s=foo&f=activationState=DISABLED" # rubocop:disable Metrics/LineLength
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
        d: "deployedBy",
        o: "name",
        s: "foo",
        f: "activationState=DISABLED"
      )
    end

    it "performs the expected request" do
      expect(response).to all be_a Bonita::Bpm::Process
    end
  end

  describe "#instantiate" do
    let(:path) { "bonita/API/bpm/process/1/instantiation" }

    let(:request_body) do
      {
        foo: "bar"
      }
    end

    let(:response_body) do
      {
        caseId: "123"
      }
    end

    let(:connection) do
      build_connection do |stub|
        stub.post(path, request_body.to_json) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) { subject.instantiate(request_body, processId: 1) }

    it "performs the expected request" do
      expect(response).to eq response_body
    end
  end

  describe "#update" do
    let(:path) { "bonita/API/bpm/process/1" }

    let(:request_body) do
      {
        activationState: "DISABLED",
        displayDescription: "updated description",
        displayName: "updated name"
      }
    end

    let(:response_body) do
      {
        id: "1",
        icon: "/default/process.png",
        displayDescription: "updated description",
        deploymentDate: "2015-01-02 14:21:18.421",
        description: "another process description",
        activationState: "DISABLED",
        name: "Pool1",
        deployedBy: "2",
        displayName: "updated name",
        actorinitiatorid: "2",
        last_update_date: "2015-01-02 14:21:18.529",
        configurationState: "RESOLVED",
        version: "1.0"
      }
    end

    let(:connection) do
      build_connection do |stub|
        stub.put(path, request_body.to_json) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) { subject.update(Bonita::Bpm::Process.new(request_body), processId: 1) }

    it "performs the expected request" do
      expect(response).to eq Bonita::Bpm::Process.new(response_body)
    end
  end
end
