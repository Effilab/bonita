# frozen_string_literal: true

RSpec.describe Bonita::Portal::ProfileResource, type: :integration do
  subject { described_class.new(connection: connection) }

  describe "#read" do
    let(:path) { "/bonita/API/portal/profile/1" }

    let(:response_body) do
      {
        id: "_profile id_",
        creationDate: "_date and time of profile creation_",
        icon: "_icon used in the portal to represent the profile_",
        createdBy: "_id of the uer who created the profile_",
        description: "_a description of the profile_",
        name: "_profile name_",
        is_default: "_true | false _",
        lastUpdateDate: "_date and time of the last update to the profile_",
        updatedBy: "_the id of the user who last updated the profile_"
      }
    end

    let(:connection) do
      build_connection do |stub|
        stub.get(path) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) { subject.read(profileId: 1) }

    it "performs the expected request" do
      expect(response).to eq(Bonita::Portal::Profile.new(response_body))
    end
  end

  describe "#search" do
    let(:path) { "/bonita/API/portal/profile?c=10&f=name=administrator&?p=2" }

    let(:response_body) do
      [
        {
          id: "_profile id_",
          creationDate: "_date and time of profile creation_",
          icon: "_icon used in the portal to represent the profile_",
          createdBy: "_id of the uer who created the profile_",
          description: "_a description of the profile_",
          name: "administrator",
          is_default: "_true | false _",
          lastUpdateDate: "_date and time of the last update to the profile_",
          updatedBy: "_the id of the user who last updated the profile_"
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
        f: "name=administrator"
      )
    end

    it "performs the expected request" do
      expect(response.first).to eq(
        Bonita::Portal::Profile.new(response_body.first)
      )
    end
  end

  describe "#create" do
    let(:path) { "/bonita/API/portal/profile" }

    let(:request_body) do
      {
        description: "This is my custom profile",
        name: "MyCustomProfile"
      }
    end

    let(:response_body) do
      {
        id: "101",
        creationDate: "2014-12-04 16:29:23.434",
        icon: "/profiles/profileDefault.png",
        createdBy: "1",
        description: "This is my custom profile",
        name: "MyCustomProfile",
        is_default: "false",
        lastUpdateDate: "2014-12-04 16:29:23.434",
        updatedBy: "1"
      }
    end

    let(:connection) do
      build_connection do |stub|
        stub.post(path, request_body.to_json) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) do
      subject.create(Bonita::Portal::Profile.new(request_body))
    end

    it "performs the expected request" do
      expect(response).to eq Bonita::Portal::Profile.new(response_body)
    end
  end

  describe "#update" do
    let(:path) { "/bonita/API/portal/profile/1" }

    let(:request_body) do
      {
        description: "This is my updated custom profile",
        id: "101",
        name: "MyUpdatedCustomProfile"
      }
    end

    let(:connection) do
      build_connection do |stub|
        stub.put(path, request_body.to_json) { [200, {}, nil] }
      end
    end

    let(:response) do
      subject.update(Bonita::Portal::Profile.new(request_body), profileId: 1)
    end

    it "performs the expected request" do
      expect(response).to be true
    end
  end

  describe "#delete" do
    let(:path) { "/bonita/API/portal/profile/1" }

    let(:connection) do
      build_connection do |stub|
        stub.delete(path) { [200, {}, nil] }
      end
    end

    let(:response) do
      subject.delete(profileId: 1)
    end

    it "performs the expected request" do
      expect(response).to be true
    end
  end
end
