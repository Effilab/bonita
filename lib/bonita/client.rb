# frozen_string_literal: true

module Bonita
  class Client
    attr_reader :username, :password, :url, :redirect_url, :tenant

    RESOURCES =
      {
        customuserinfo: {
          definitions: Customuserinfo::DefinitionResource,
          users: Customuserinfo::UserResource,
          values: Customuserinfo::ValueResource
        },
        bpm: {
          cases: Bpm::CaseResource,
          case_variables: Bpm::CaseVariableResource,
          processes: Bpm::ProcessResource,
          user_tasks: Bpm::UserTaskResource,
          messages: Bpm::MessageResource
        },
        bdm: {
          business_data: Bdm::BusinessDataResource
        },
        identity: {
          groups: Identity::GroupResource,
          memberships: Identity::MembershipResource,
          roles: Identity::RoleResource,
          users: Identity::UserResource
        },
        portal: {
          profiles: Portal::ProfileResource,
          profile_members: Portal::ProfileMemberResource
        }
      }.freeze

    RESOURCES.each do |key, value|
      if value.is_a? Hash
        mod = Object.const_get("Bonita::#{key.capitalize}")
        mod.module_eval do
          value.each do |k, v|
            define_singleton_method(k) { v.new(connection: connection) }
          end
        end

        define_method(key) do
          this = self
          mod.define_singleton_method(:connection) { this.connection }
          mod
        end
      else
        define_method(key) { value.new(connection: connection) }
      end
    end

    def self.start(options = {})
      client = new(options)
      client.login

      yield(client)
    ensure
      client.logout
    end

    def initialize(options = {})
      @url = options[:url]
      @username = options[:username]
      @password = options[:password]
      @tenant = options[:tenant]
      @logger = options[:logger]
      @log_api_bodies = options[:log_api_bodies]
      @logged_in = false
    end

    def login
      return if logged_in?

      response =
        connection.post "/bonita/loginservice" do |req|
          req.headers["Content-Type"] = "application/x-www-form-urlencoded"
          body = {
            username: @username,
            password: @password
          }
          body[:tenant] = @tenant if @tenant
          req.body = body
        end

      raise Bonita::AuthError, "Unable to log in" if response.body.include?("Unable to log in")

      @logged_in = true
    end

    def logout
      return unless logged_in?

      connection.get "/bonita/logoutservice?redirect=false"
      @logged_in = false
      true
    end

    def connection
      @connection ||=
        Faraday.new connection_options do |conn|
          conn.use :cookie_jar
          conn.use Bonita::Middleware::CSRF
          conn.use Faraday::Request::UrlEncoded
          conn.response :logger, logger, bodies: log_api_bodies?
          conn.adapter Faraday.default_adapter
        end
    end

    def logged_in?
      @logged_in
    end

    private

    def logger
      @logger || ::Logger.new($stderr)
    end

    def log_api_bodies?
      @log_api_bodies || false
    end

    def connection_options
      {
        url: @url,
        request: {
          params_encoder: Faraday::FlatParamsEncoder
        },
        headers: {
          content_type: "application/json"
        }
      }
    end
  end
end
