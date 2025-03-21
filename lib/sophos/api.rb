# frozen_string_literal: true

require 'wrapi'
require File.expand_path('configuration', __dir__)
require File.expand_path('authentication', __dir__)

module Sophos
  # Handles API configuration, connections, and authentication.
  # This class manages settings such as API keys, tokens, and endpoint configurations,
  # and includes necessary modules for making authenticated API calls.
  class API
    # Attribute accessors for configuration keys
    # These keys include essential settings such as client ID, client secret, and API endpoint.
    attr_accessor(*Configuration::VALID_OPTIONS_KEYS)

    # Initializes a new API instance and applies configuration settings.
    #
    # @param options [Hash] A hash of options to configure the API.
    #   These options are merged with global configuration settings.
    #
    # @example Initialize a new API instance with custom options:
    #   api = Sophos::API.new(client_id: 'your_client_id', client_secret: 'your_client_secret')
    #
    def initialize(options = {})
      # Merge provided options with the global Sophos configuration
      options = Sophos.options.merge(options)

      # Set instance variables for each valid configuration key
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    # Returns the current API configuration as a hash.
    #
    # @return [Hash] A hash of the current API configuration.
    #
    # @example Retrieve the current API configuration:
    #   api = Sophos::API.new
    #   api.config  # => { client_id: 'abc', client_secret: 'xyz' }
    #
    def config
      conf = {}
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        conf[key] = send(key)
      end
      conf
    end

    # Including modules for API connection, request handling, and authentication
    include Configuration
    include WrAPI::Connection
    include WrAPI::Request
    include Authentication
  end
end
