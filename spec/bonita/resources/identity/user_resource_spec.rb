# frozen_string_literal: true

RSpec.describe Bonita::Identity::UserResource, type: :integration do
  subject { described_class.new(connection: connection) }

  describe "#read" do
    let(:path) { "/bonita/API/identity/user/1?d=professional_data&d=manager_id" }

    let(:response_body) do
      {
        last_connection: "date",
        created_by_user_id: "number",
        creation_date: "date",
        id: "number",
        icon: "string",
        enabled: "true | false",
        title: "string",
        professional_data: {
          fax_number: "string",
          building: "string",
          phone_number: "string",
          website: "string",
          zipcode: "string",
          state: "string",
          city: "string",
          country: "string",
          id: "number",
          mobile_number: "string",
          address: "string",
          email: "string",
          room: "string"
        },
        manager_id: {
          last_connection: "date",
          created_by_user_id: "number",
          creation_date: "date",
          id: "number",
          icon: "string",
          enabled: "true | false",
          title: "string",
          manager_id: "number",
          job_title: "string",
          userName: "string",
          lastname: "string",
          firstname: "string",
          password: "",
          last_update_date: "date"
        },
        job_title: "string",
        userName: "string",
        lastname: "string",
        firstname: "string",
        password: "",
        last_update_date: "date"
      }
    end

    before do
      stub_request(connection) do |stub|
        stub.get(path) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) { subject.read(userId: 1, d: %w[professional_data manager_id]) }

    it "performs the expected request" do
      expect(response).to eq Bonita::Identity::User.new(response_body)
    end
  end

  describe "#search" do
    let(:path) { "/bonita/API/identity/user?p=0&c=10&o=lastname%20ASC&s=will&f=enabled%3dtrue" }

    let(:response_body) do
      [
        {
          last_connection: "2014-12-09 14:52:06.092",
          created_by_user_id: "-1",
          creation_date: "2014-12-08 17:16:40.984",
          id: "1",
          icon: "/default/icon_user.png",
          enabled: "true",
          title: "Mr",
          manager_id: "0",
          job_title: "Chief Executive Officer",
          userName: "william.jobs",
          lastname: "Jobs",
          firstname: "William",
          password: "",
          last_update_date: "2014-12-08 17:16:40.984"
        }
      ]
    end

    before do
      stub_request(connection) do |stub|
        stub.get(path) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) do
      subject.search(
        p: 0,
        c: 10,
        o: "lastname ASC",
        s: "will",
        f: "enabled=true"
      )
    end

    it "performs the expected request" do
      expect(response.first).to eq(
        Bonita::Identity::User.new(response_body.first)
      )
    end
  end

  describe "#create" do
    let(:path) { "/bonita/API/identity/user" }

    let(:request_body) do
      {
        firstname: "New",
        icon: "",
        job_title: "Human resources benefits",
        lastname: "User",
        manager_id: "3",
        password: "bpm",
        password_confirm: "bpm",
        title: "Mr",
        userName: "New.User"
      }
    end

    let(:response_body) do
      {
        last_connection: "",
        created_by_user_id: "4",
        creation_date: "2014-12-09 17:43:28.291",
        id: "101",
        icon: "/default/icon_user.png",
        enabled: "false",
        title: "Mr",
        manager_id: "3",
        job_title: "Human resources benefits",
        userName: "New.User",
        lastname: "New",
        firstname: "User",
        password: "",
        last_update_date: "2014-12-09 17:43:28.291"
      }
    end

    before do
      stub_request(connection) do |stub|
        stub.post(path, request_body.to_json) { [200, {}, response_body.to_json] }
      end
    end

    let(:response) do
      subject.create(Bonita::Identity::User.new(request_body))
    end

    it "performs the expected request" do
      expect(response).to eq Bonita::Identity::User.new(response_body)
    end
  end

  describe "#update" do
    let(:path) { "/bonita/API/identity/user/1" }

    let(:request_body) do
      {
        firstname: "Walter",
        icon: "",
        id: "4",
        job_title: "Human resources benefits",
        lastname: "Bates",
        manager_id: "3",
        password: "bpm",
        password_confirm: "bpm",
        title: "Mr",
        userName: "walter.bates"
      }
    end

    before do
      stub_request(connection) do |stub|
        stub.put(path, request_body.to_json) { [200, {}, nil] }
      end
    end

    let(:response) do
      subject.update(Bonita::Identity::User.new(request_body), userId: 1)
    end

    it "performs the expected request" do
      expect(response).to be true
    end
  end

  describe "#delete" do
    let(:path) { "/bonita/API/identity/user/1" }

    before do
      stub_request(connection) do |stub|
        stub.delete(path) { [200, {}, nil] }
      end
    end

    let(:response) do
      subject.delete(userId: 1)
    end

    it "performs the expected request" do
      expect(response).to be true
    end
  end

  describe "#enable" do
    let(:path) { "/bonita/API/identity/user/1" }

    before do
      stub_request(connection) do |stub|
        stub.put(path) { [200, {}, nil] }
      end
    end

    let(:response) do
      subject.enable(userId: 1)
    end

    it "performs the expected request" do
      expect(response).to be true
    end
  end

  describe "#disable" do
    let(:path) { "/bonita/API/identity/user/1" }

    before do
      stub_request(connection) do |stub|
        stub.put(path) { [200, {}, nil] }
      end
    end

    let(:response) do
      subject.disable(userId: 1)
    end

    it "performs the expected request" do
      expect(response).to be true
    end
  end
end
