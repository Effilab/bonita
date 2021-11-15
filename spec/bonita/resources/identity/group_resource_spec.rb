# frozen_string_literal: true

RSpec.describe Bonita::Identity::GroupResource, type: :integration do
  subject { described_class.new(connection: connection) }

  describe "#read" do
    let(:path) { "/bonita/API/identity/group/1" }

    let(:response_body) do
      {
        id: "group ID",
        name: "display name",
        displayName: "name",
        parent_path: "the path of the parent group of this group",
        path: "the full path of the group",
        description: "description",
        creation_date: "2014-12-31 15:17:24.736",
        created_by_user_id: "id of the user who created the group (-1 if the group was created by tenant or by import)",
        last_update_date: "2014-12-31 15:17:24.736",
        icon: "icon path"
      }
    end

    let(:connection) do
      build_connection do |stub|
        stub.get(path) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) { subject.read(groupId: 1) }

    it "performs the expected request" do
      expect(response).to eq Bonita::Identity::Group.new(response_body)
    end
  end

  describe "#search" do
    let(:path) { "/bonita/API/identity/group?p=0&c=100&f=parent_path%3d/acme&d=parent_group_id&o=name%20ASC" }

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
        p: 0,
        c: 100,
        f: "parent_path=/acme",
        d: "parent_group_id",
        o: "name ASC"
      )
    end

    it "performs the expected request" do
      expect(response).to all be_a Bonita::Identity::Group
    end
  end

  describe "#create" do
    let(:path) { "/bonita/API/identity/group" }

    let(:request_body) do
      {
        description: "Human resources department",
        displayName: "Human Resources",
        icon: "",
        name: "HR",
        parent_group_id: "1"
      }
    end

    let(:response_body) do
      {
        id: "14",
        creation_date: "2014-12-02 16:19:28.925",
        created_by_user_id: "4",
        icon: "",
        parent_path: "/acme/HR",
        description: "Human resources department",
        name: "HR",
        path: "/acme/HR",
        displayName: "Human Resources",
        last_update_date: "2014-12-02 16:19:28.925"
      }
    end

    let(:connection) do
      build_connection do |stub|
        stub.post(path, request_body.to_json) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) do
      subject.create(Bonita::Identity::Group.new(request_body))
    end

    it "performs the expected request" do
      expect(response).to eq Bonita::Identity::Group.new(response_body)
    end
  end

  describe "#create" do
    let(:path) { "/bonita/API/identity/group" }

    let(:request_body) do
      {
        description: "Human resources department",
        displayName: "Human Resources",
        icon: "",
        name: "HR",
        parent_group_id: "1"
      }
    end

    let(:response_body) do
      {
        id: "14",
        creation_date: "2014-12-02 16:19:28.925",
        created_by_user_id: "4",
        icon: "",
        parent_path: "/acme/HR",
        description: "Human resources department",
        name: "HR",
        path: "/acme/HR",
        displayName: "Human Resources",
        last_update_date: "2014-12-02 16:19:28.925"
      }
    end

    let(:connection) do
      build_connection do |stub|
        stub.post(path, request_body.to_json) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) do
      subject.create(Bonita::Identity::Group.new(request_body))
    end

    it "performs the expected request" do
      expect(response).to eq Bonita::Identity::Group.new(response_body)
    end
  end

  describe "#update" do
    let(:path) { "/bonita/API/identity/group/1" }

    let(:request_body) do
      {
        displayName: "Human Resources",
        name: "HR"
      }
    end

    let(:response_body) do
      {
        id: "14",
        creation_date: "2014-12-02 16:19:28.925",
        created_by_user_id: "4",
        icon: "",
        parent_path: "/acme/HR",
        description: "Human resources department",
        name: "HR",
        path: "/acme/HR",
        displayName: "Human Resources",
        last_update_date: "2014-12-02 16:19:28.925"
      }
    end

    let(:connection) do
      build_connection do |stub|
        stub.put(path, request_body.to_json) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) do
      subject.update(Bonita::Identity::Group.new(request_body), groupId: 1)
    end

    it "performs the expected request" do
      expect(response).to eq Bonita::Identity::Group.new(response_body)
    end
  end

  describe "#update" do
    let(:path) { "/bonita/API/identity/group/1" }

    let(:request_body) do
      {
        displayName: "Human Resources",
        name: "HR"
      }
    end

    let(:response_body) do
      {
        id: "14",
        creation_date: "2014-12-02 16:19:28.925",
        created_by_user_id: "4",
        icon: "",
        parent_path: "/acme/HR",
        description: "Human resources department",
        name: "HR",
        path: "/acme/HR",
        displayName: "Human Resources",
        last_update_date: "2014-12-02 16:19:28.925"
      }
    end

    let(:connection) do
      build_connection do |stub|
        stub.put(path, request_body.to_json) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) do
      subject.update(Bonita::Identity::Group.new(request_body), groupId: 1)
    end

    it "performs the expected request" do
      expect(response).to eq Bonita::Identity::Group.new(response_body)
    end
  end

  describe "#delete" do
    let(:path) { "/bonita/API/identity/group/1" }

    let(:connection) do
      build_connection do |stub|
        stub.delete(path) { [200, {}, nil] }
      end
    end

    let(:response) do
      subject.delete(groupId: 1)
    end

    it "performs the expected request" do
      expect(response).to be true
    end
  end
end
