# frozen_string_literal: true

RSpec.describe Bonita::Identity::MembershipResource, type: :integration do
  subject { described_class.new(connection: connection) }

  describe "#search" do
    let(:path) { "/bonita/API/identity/membership?p=0&c=10&f=user_id%3d125&d=role_id" }

    let(:response_body) do
      [
        {
          assigned_date: "2014-12-02 17:57:09.315",
          role_id: {
            creation_date: "2014-12-01 18:51:54.791",
            created_by_user_id: "4",
            id: "4",
            icon: "",
            description: "manager of the department",
            name: "manager",
            displayName: "department manager",
            last_update_date: "2014-12-01 18:51:54.791"
          },
          assigned_by_user_id: "12",
          group_id: "5",
          user_id: "125"
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
        f: "user_id=125",
        d: "role_id"
      )
    end

    it "performs the expected request" do
      expect(response.first).to eq(
        Bonita::Identity::MembershipMapping.extract_single(response_body.first.to_json, :read)
      )
    end
  end

  describe "#create" do
    let(:path) { "/bonita/API/identity/membership" }

    let(:request_body) do
      {
        group_id: "5",
        role_id: "1",
        user_id: "4"
      }
    end

    let(:response_body) do
      {
        assigned_date: "2014-12-02 17:57:09.315",
        role_id: "1",
        assigned_by_user_id: "-1",
        group_id: "5",
        user_id: "4"
      }
    end

    let(:connection) do
      build_connection do |stub|
        stub.post(path, request_body.to_json) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) do
      subject.create(Bonita::Identity::Membership.new(request_body))
    end

    it "performs the expected request" do
      expect(response).to eq Bonita::Identity::Membership.new(response_body)
    end
  end

  describe "#delete" do
    let(:path) { "/bonita/API/identity/membership/1/2/3" }

    let(:connection) do
      build_connection do |stub|
        stub.delete(path) { [200, {}, nil] }
      end
    end

    let(:response) do
      subject.delete(userId: 1, groupId: 2, roleId: 3)
    end

    it "performs the expected request" do
      expect(response).to be true
    end
  end
end
