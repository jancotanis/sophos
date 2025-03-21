# frozen_string_literal: true

require 'wrapi'
require File.expand_path('version', __dir__)
require File.expand_path('pagination', __dir__)

module Sophos
  # Configuration module for setting API-related options and defaults.
  #
  # This module extends `WrAPI::Configuration` and defines additional constants,
  # default values, and methods to handle the configuration of the Sophos API wrapper.
  module Configuration
    include WrAPI::Configuration

    # Additional valid configuration keys for [Sophos::API].
    VALID_OPTIONS_KEYS = (WrAPI::Configuration::VALID_OPTIONS_KEYS + %i[
      partner_id tenant_id id_endpoint
    ])

    attr_accessor(*VALID_OPTIONS_KEYS)

    # Default settings
    DEFAULT_ENDPOINT = 'https://api.central.sophos.com'
    DEFAULT_ID_ENDPOINT = 'https://id.sophos.com'
    DEFAULT_USER_AGENT = "Sophos Ruby API wrapper #{Sophos::VERSION}"
    DEFAULT_PAGINATION = Sophos::RequestPagination::PagesPagination
    DEFAULT_PAGE_SIZE = 100

    # Initialize configuration defaults when this module is extended.
    def self.extended(base)
      base.reset
    end

    # Returns the current configuration as a hash of key-value pairs.
    #
    # @return [Hash] Current configuration options.
    def options
      VALID_OPTIONS_KEYS.each_with_object({}) do |key, option|
        option[key] = send(key)
      end
    end

    # Resets all configuration options to their default values.
    def reset
      super
      self.partner_id = nil
      self.tenant_id = nil

      self.endpoint = DEFAULT_ENDPOINT
      self.id_endpoint = DEFAULT_ID_ENDPOINT
      self.user_agent = DEFAULT_USER_AGENT
      self.page_size = DEFAULT_PAGE_SIZE
      self.pagination_class = DEFAULT_PAGINATION
    end
  end
end
