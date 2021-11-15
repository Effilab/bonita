# frozen_string_literal: true

RSpec.describe Bonita::Portal::ProfileMemberResource, type: :integration do
  subject { described_class.new(connection: connection) }

  describe "#search" do
    let(:path) { "/bonita/API/portal/profileMember?c=10&f=member_type=user&?p=2" }

    let(:response_body) do
      [
        {
          id: "_profileMemberid_",
          profile_id: "_id of the profile for this mapping_",
          role_id: "_id of role, or -1 if the member type is not role_",
          group_id: "_id of group, or -1 if the member type is not group_",
          user_id: "_id of user, or -1 if the member type is not user_"
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
        c: 10,
        p: 2,
        f: "member_type=user"
      )
    end

    it "performs the expected request" do
      expect(response.first).to eq(
        Bonita::Portal::ProfileMember.new(response_body.first)
      )
    end
  end

  describe "#create" do
    let(:path) { "/bonita/API/portal/profileMember" }

    let(:request_body) do
      {
        member_type: "USER",
        profile_id: "2",
        user_id: "101"
      }
    end

    let(:response_body) do
      {
        id: "204",
        profile_id: "2",
        role_id: "-1",
        group_id: "-1",
        user_id: "101"
      }
    end

    let(:connection) do
      build_connection do |stub|
        stub.post(path, request_body.to_json) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) do
      subject.create(Bonita::Portal::ProfileMember.new(request_body))
    end

    it "performs the expected request" do
      expect(response).to eq Bonita::Portal::ProfileMember.new(response_body)
    end
  end

  describe "#delete" do
    let(:path) { "/bonita/API/portal/profileMember/1" }

    let(:connection) do
      build_connection do |stub|
        stub.delete(path) { [200, {}, nil] }
      end
    end

    let(:response) do
      subject.delete(profileMemberId: 1)
    end

    it "performs the expected request" do
      expect(response).to be true
    end
  end
end
