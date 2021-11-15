# frozen_string_literal: true

RSpec.describe Bonita::Identity::RoleResource, type: :integration do
  subject { described_class.new(connection: connection) }

  describe "#read" do
    let(:path) { "/bonita/API/identity/role/1" }

    let(:response_body) do
      {
        creation_date: "2014-12-01 15:17:24.736",
        created_by_user_id: "-1",
        id: "1",
        icon: "",
        description: "",
        name: "member",
        displayName: "Member",
        last_update_date: "2014-12-01 15:17:24.736"
      }
    end

    let(:connection) do
      build_connection do |stub|
        stub.get(path) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) { subject.read(roleId: 1) }

    it "performs the expected request" do
      expect(response).to eq Bonita::Identity::Role.new(response_body)
    end
  end

  describe "#search" do
    let(:path) { "/bonita/API/identity/role?p=0&c=10&o=displayName ASC" }

    let(:response_body) do
      [
        {
          creation_date: "2014-12-01 15:17:24.736",
          created_by_user_id: "-1",
          id: "1",
          icon: "",
          description: "",
          name: "member",
          displayName: "Member",
          last_update_date: "2014-12-01 15:17:24.736"
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
        p: 0,
        c: 10,
        o: "displayName ASC",
        f: "name=member"
      )
    end

    it "performs the expected request" do
      expect(response.first).to eq(
        Bonita::Identity::Role.new(response_body.first)
      )
    end
  end

  describe "#create" do
    let(:path) { "/bonita/API/identity/role" }

    let(:request_body) do
      {
        displayName: "department manager",
        name: "manager",
        description: "manager of the department",
        icon: ""
      }
    end

    let(:response_body) do
      {
        creation_date: "2014-12-01 18:51:54.791",
        created_by_user_id: "4",
        id: "4",
        icon: "",
        description: "manager of the department",
        name: "manager",
        displayName: "department manager",
        last_update_date: "2014-12-01 18:51:54.791"
      }
    end

    let(:connection) do
      build_connection do |stub|
        stub.post(path, request_body.to_json) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) do
      subject.create(Bonita::Identity::Role.new(request_body))
    end

    it "performs the expected request" do
      expect(response).to eq Bonita::Identity::Role.new(response_body)
    end
  end

  describe "#update" do
    let(:path) { "/bonita/API/identity/role/1" }

    let(:request_body) do
      {
        displayName: "Department manager",
        name: "Manager"
      }
    end

    let(:response_body) do
      {
        creation_date: "2014-12-01 18:51:54.791",
        created_by_user_id: "4",
        id: "4",
        icon: "",
        description: "manager of the department",
        name: "Manager",
        displayName: "Department manager",
        last_update_date: "2014-12-01 18:59:59.361"
      }
    end

    let(:connection) do
      build_connection do |stub|
        stub.put(path, request_body.to_json) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) do
      subject.update(Bonita::Identity::Role.new(request_body), roleId: 1)
    end

    it "performs the expected request" do
      expect(response).to eq Bonita::Identity::Role.new(response_body)
    end
  end

  describe "#delete" do
    let(:path) { "/bonita/API/identity/role/1" }

    let(:connection) do
      build_connection do |stub|
        stub.delete(path) { [200, {}, nil] }
      end
    end

    let(:response) do
      subject.delete(roleId: 1)
    end

    it "performs the expected request" do
      expect(response).to be true
    end
  end
end
