# frozen_string_literal: true

require 'faraday'
require 'json'
require 'uri'
require File.expand_path('error', __dir__)

module Sophos
  # Handles authentication flow for accessing Sophos APIs and stores tokens in global configuration.
  # This module manages OAuth2-based token generation and sets up the API connection with authorization headers.
  # 
  # @note Ensure that `client_id` and `client_secret` are configured before calling authentication methods.
  # @see https://developer.sophos.com/getting-started
  module Authentication

    # Authorizes with the Sophos portal and retrieves an access token.
    # This method performs an OAuth2 client credentials flow, returning a valid token.
    #
    # @param _options [Hash] (optional) Any additional options for the request.
    # @return [String] Access token for the Sophos API.
    # @raise [ConfigurationError] If `client_id` or `client_secret` is not set.
    # @raise [AuthenticationError] If authentication fails due to invalid credentials or other errors.
    #
    # @example Authenticate and retrieve a token:
    #   api.auth_token
    #
    def auth_token(_options = {})
      raise ConfigurationError.new 'Client id and/or secret not configured' unless client_id && client_secret

      # POST request to obtain the OAuth2 token using client credentials
      response = connection.post("#{id_endpoint}/api/v2/oauth2/token") do |request|
        request.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        request.body = URI.encode_www_form(api_access_token_params)
      end

      api_process_token(response.body)
      setup_connection

      # Returns the generated access token
      self.access_token
    rescue Faraday::UnauthorizedError => e
      raise AuthenticationError.new "Unauthorized; response #{e}"
    end
    alias login auth_token

    private

    # Builds the request body parameters for the token request.
    # 
    # @return [Hash] Parameters required for the client credentials grant type.
    def api_access_token_params
      {
        grant_type: 'client_credentials',
        client_id: client_id,
        client_secret: client_secret,
        scope: 'token'
      }
    end

    # Processes the token response and extracts authentication details.
    #
    # @param response [Hash] The HTTP response body containing the OAuth2 token data.
    # @raise [AuthenticationError] If `access_token` is missing or invalid.
    def api_process_token(response)
      self.access_token  = response['access_token']
      self.token_type    = response['token_type']
      self.refresh_token = response['refresh_token']
      self.token_expires = response['expires_in']

      if self.access_token.nil? || self.access_token.empty?
        raise AuthenticationError.new "Could not find valid access_token; response #{response}"
      end
    end

    # Sets up the API connection using the authenticated token and partner-specific settings.
    #
    # This method retrieves the partner ID, sets the global endpoint, and configures headers.
    # 
    # @raise [AuthenticationError] If the partner ID is not returned in the `whoami` response.
    def setup_connection
      partner = self.get("/whoami/v1")

      if 'partner'.eql?(partner.idType) && partner.id
        self.partner_id = partner.id
        self.endpoint = partner.apiHosts.global
        self.connection_options = { headers: { 'X-partner-id': self.partner_id } }
      else
        raise AuthenticationError.new "Partner id not returned; response #{partner}"
      end
    end
  end
end
