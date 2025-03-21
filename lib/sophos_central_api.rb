# frozen_string_literal: true

require 'wrapi'
require File.expand_path('sophos/api', __dir__)
require File.expand_path('sophos/client', __dir__)

# Main module to interact with the Sophos API.
# This module provides access to the Sophos client, which handles API calls and manages configurations.
#
# @example Initialize a Sophos client:
#   client = Sophos.client(
#     client_id: 'your_client_id',
#     client_secret: 'your_client_secret'
#   )
#
module Sophos
  extend Configuration
  extend WrAPI::RespondTo

  # Initializes and returns a new instance of the Sophos client.
  #
  # @param options [Hash] A hash of options to configure the client.
  #   Supported options include:
  #   - `:client_id` [String] - Your Sophos API client ID.
  #   - `:client_secret` [String] - Your Sophos API client secret.
  #   - `:endpoint` [String] - The base URL for the API (default: Sophos Central endpoint).
  #
  # @return [Sophos::Client] An instance of the Sophos client with the provided configuration.
  #
  # @example Create a client with default settings:
  #   Sophos.client
  #
  # @example Create a client with custom options:
  #   Sophos.client(client_id: 'abc123', client_secret: 'xyz789')
  #
  def self.client(options = {})
    Sophos::Client.new(options)
  end
end
