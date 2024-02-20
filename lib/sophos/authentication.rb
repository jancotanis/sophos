require 'faraday'
require 'json'
require 'uri'
require File.expand_path('error', __dir__)

module Sophos
  # Deals with authentication flow and stores it within global configuration
  module Authentication

    # Authorize to the Sophos portal and return access_token
    # @see https://developer.sophos.com/getting-started
    def auth_token(options = {})
      raise ConfigurationError.new 'Client id and/or secret not configured' unless client_id && client_secret
      # use id endpoint instead of global api
      response = connection.post(id_endpoint+'/api/v2/oauth2/token') do |request|
        request.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        request.body = URI.encode_www_form( api_access_token_params )
      end
      api_process_token(response.body)

      # use default endpoint and replace it with global endpoint
      partner = self.get( "/whoami/v1" )
      if 'partner'.eql?(partner.idType) && partner.id
        self.partner_id = partner.id
        self.endpoint = partner.apiHosts.global
        self.connection_options = { headers: { 'X-partner-id': self.partner_id } }
      else
        raise AuthenticationError.new 'Partner id not returned; response ' + response.to_s
      end
    rescue Faraday::UnauthorizedError => e
        raise AuthenticationError.new 'Unauthorized; response ' + e.to_s
    end
    alias login auth_token

  private

    def api_access_token_params
      {
        grant_type: 'client_credentials',
        client_id: client_id,
        client_secret: client_secret,
        scope: 'token'
      }
    end

    def api_process_token(response)
      at = self.access_token = response['access_token']
      self.token_type        = response['token_type']
      self.refresh_token     = response['refresh_token']
      self.token_expires     = response['expires_in']
      raise AuthenticationError.new 'Could not find valid access_token; response ' + response.to_s if at.nil? || at.empty?

      at
    end
  end
end
