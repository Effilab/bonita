# frozen_string_literal: true

RSpec.describe Bonita::Client, type: :integration do
  let(:url) { "http://bonita_host.com" }
  let(:username) { "username" }
  let(:password) { "password" }
  let(:tenant) { "tenant" }
  let(:logger) { double("logger", info: nil, debug: nil) }
  let(:options) do
    {
      url: url,
      username: username,
      password: password,
      tenant: tenant,
      logger: logger,
      log_api_bodies: true
    }
  end

  subject do
    described_class.new(options)
  end

  shared_context "logged in" do
    before { allow(subject).to receive(:logged_in?).and_return true }
  end

  shared_context "logged out" do
    before { allow(subject).to receive(:logged_in?).and_return false }
  end

  describe ".start" do
    let(:client) { double("client", login: nil, logout: nil) }

    before do
      allow(described_class).to receive(:new).with(options).and_return(client)
    end

    it "logs in" do
      expect(client).to receive(:login)
      described_class.start(options) {}
    end

    it "yields to the block" do
      expect { |b| described_class.start(options, &b) }.to yield_with_args(client)
    end

    it "ensures logging out" do
      expect(client).to receive(:logout)
      expect { described_class.start(options) { raise "an_error" } }.to raise_error "an_error"
    end
  end

  describe "#login" do
    context "when unable to log in" do
      let(:connection) do
        build_connection do |stub|
          stub.post("/bonita/loginservice") { [200, {}, "Unable to log in"] }
        end
      end

      before do
        allow(subject).to receive(:connection) { connection }
      end

      it "raises Bonita::AuthError" do
        expect { subject.login }.to raise_error Bonita::AuthError, "Unable to log in"
      end
    end

    context "when able to log in" do
      context "when logged in" do
        include_context "logged in"

        it "does not perform additional request" do
          expect(subject.connection).not_to receive(:post)
          subject.login
        end
      end

      context "when logged out" do
        include_context "logged out"

        let(:req) { double("request", headers: headers, body: nil, "body=": nil) }
        let(:headers) { {} }
        let(:response) { double("response", body: "ok") }

        shared_examples "a login request" do
          it "calls the endpoint with the proper params" do
            expect(subject.connection).to(
              receive(:post).with("/bonita/loginservice").and_yield(req).and_return(response)
            )
            expect(headers).to receive("[]=").with("Content-Type", "application/x-www-form-urlencoded")
            expect(req).to receive(:body=).with(expected_body)
            result = subject.login
            expect(result).to be true
          end
        end

        context "with a tenant" do
          let(:tenant) { "tenant" }
          let(:expected_body) { {username: "username", password: "password", tenant: "tenant"} }

          it_behaves_like "a login request"
        end

        context "without a tenant" do
          let(:tenant) { nil }
          let(:expected_body) { {username: "username", password: "password"} }

          it_behaves_like "a login request"
        end
      end
    end
  end

  describe "#logout" do
    context "when logged in" do
      include_context "logged in"

      it "requests the logout url" do
        expect(subject.connection).to receive(:get).with("/bonita/logoutservice?redirect=false")
        subject.logout
      end
    end

    context "when logged out" do
      include_context "logged out"

      it "does not request the logout url" do
        expect(subject.connection).not_to receive(:get)
        subject.logout
      end
    end
  end

  describe "#connection" do
    let(:connection_options) do
      {
        url: url,
        request: {
          params_encoder: Faraday::FlatParamsEncoder
        },
        headers: {
          content_type: "application/json"
        }
      }
    end
    let(:conn) { double("connection", use: nil, adapter: nil, response: nil) }

    it "instantiates a properly configured Farday::Connection object" do
      expect(Faraday).to receive(:new).with(connection_options).and_yield(conn)
      expect(conn).to receive(:use).with(:cookie_jar)
      expect(conn).to receive(:use).with(Bonita::Middleware::CSRF)
      expect(conn).to receive(:use).with(Faraday::Request::UrlEncoded)
      expect(conn).to receive(:adapter).with(Faraday.default_adapter)
      expect(conn).to receive(:response).with(:logger, logger, bodies: true)
      subject.connection
    end
  end

  describe "dynamic methods" do
    described_class::RESOURCES.each do |key, value|
      describe "##{key}" do
        it "returns Bonita::#{key.capitalize} constant" do
          expect(subject.public_send(key)).to eql Object.const_get("Bonita::#{key.capitalize}")
        end

        value.each do |k, v|
          describe "##{k}" do
            it "returns #{v} constant" do
              expect(
                subject.public_send(key).public_send(k).class
              ).to eql Object.const_get(v.to_s)
            end
          end
        end
      end
    end
  end
end
