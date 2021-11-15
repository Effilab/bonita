# frozen_string_literal: true

RSpec.describe Bonita::Bpm::UserTaskResource, type: :integration do
  subject { described_class.new(connection: connection) }

  describe "#find" do
    let(:path) { "bonita/API/bpm/userTask/1" }

    let(:response_body) do
      {
        id: "the task id (long)",
        type: "the task type (string): USER_TASK",
        name: "the task technical name (string)",
        displayName: "the human readable task name (string)",
        description: "the task description (string)",
        displayDescription: "the human readable task description (string)",
        state: "the current state of the task (string, possible values: ready, completed, failed)",
        reached_state_date: "the date ('yyyy-MM-dd HH:mm:ss.SSS')",
        last_update_date: "the date ('yyyy-MM-dd HH:mm:ss.SSS') when this task was last updated",
        dueDate: "the date ('yyyy-MM-dd HH:mm:ss.SSS') when this task is due, for example '2014-10-17 16:05:42.626'",
        priority: "the priority (string) of the current task",
        processId: "the process definition id (long) of the case which define this task",
        parentCaseId: "the immediate containing case id (long, a.k.a process instance id)",
        rootCaseId: "the top/root case id (long, a.k.a process instance id).",
        rootContainerId: "same as rootCaseId",
        executedBy: "the id (long) of the user who performed this task.",
        executedBySubstitute: "the id of the user who did actually performed the task in the name of someone else.",
        actorId: "the id (long) of the actor that can execute this task, null otherwise",
        assigned_id: "the user id (long) that this task is assigned to, or 0 if it is unassigned",
        assigned_date: "the date ('yyyy-MM-dd HH:mm:ss.SSS') when the current task was assigned"
      }
    end

    before do
      stub_request(connection) do |stub|
        stub.get(path) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) { subject.find(userTaskId: 1) }

    it "performs the expected request" do
      expect(response).to eq Bonita::Bpm::UserTask.new(response_body)
    end
  end

  describe "#context" do
    let(:path) do
      "bonita/API/bpm/userTask/1/context"
    end

    let(:response_body) do
      {foo: "bar"}
    end

    before do
      stub_request(connection) do |stub|
        stub.get(path) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) do
      subject.context(userTaskId: 1)
    end

    it "performs the expected request" do
      expect(response).to eq response_body
    end
  end

  describe "#execution", skip: "Needs Real-life testing" do
    let(:path) { "bonita/API/bpm/userTask/1/execution" }

    let(:request_body) do
      {
        foo: "bar"
      }
    end

    before do
      stub_request(connection) do |stub|
        stub.post(path, request_body.to_json) { [200, {}, nil] }
      end
    end

    let(:response) { subject.execution(request_body, userTaskId: 1) }

    it "performs the expected request" do
      expect(response).to be true
    end
  end

  describe "#update" do
    let(:path) { "bonita/API/bpm/userTask/1" }

    let(:request_body) do
      {
        assigned_id: "id of a new user",
        state: "skipped"
      }
    end

    before do
      stub_request(connection) do |stub|
        stub.put(path, request_body.to_json) { [200, {}, nil] }
      end
    end

    let(:response) { subject.update(Bonita::Bpm::UserTask.new(request_body), userTaskId: 1) }

    it "performs the expected request" do
      expect(response).to be true
    end
  end
end
