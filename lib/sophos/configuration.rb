require 'wrapi'
require File.expand_path('version', __dir__)
require File.expand_path('pagination', __dir__)

module Sophos
  # Defines constants and methods related to configuration
  module Configuration
    include WrAPI::Configuration

    # An array of additional valid keys in the options hash when configuring a [Sophos::API]
    VALID_OPTIONS_KEYS = (WrAPI::Configuration::VALID_OPTIONS_KEYS + [:partner_id, :tenant_id, :id_endpoint]).freeze

    # @private
    attr_accessor *VALID_OPTIONS_KEYS

    DEFAULT_ENDPOINT = 'https://api.central.sophos.com'.freeze
    DEFAULT_ID_ENDPOINT = 'https://id.sophos.com'.freeze
    DEFAULT_UA = "Sophos Ruby API wrapper #{Sophos::VERSION}".freeze
    DEFAULT_PAGINATION = Sophos::RequestPagination::PagesPagination
    DEFAULT_PAGE_SIZE = 100

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Create a hash of options and their values
    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    # Reset all configuration options to defaults
    def reset
      super
      self.partner_id = nil
      self.tenant_id = nil

      self.endpoint = DEFAULT_ENDPOINT
      self.id_endpoint = DEFAULT_ID_ENDPOINT
      self.user_agent = DEFAULT_UA
      self.page_size = DEFAULT_PAGE_SIZE
      self.pagination_class = DEFAULT_PAGINATION
    end
  end
end

