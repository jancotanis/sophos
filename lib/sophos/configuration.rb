require 'wrapi'

module Sophos
  # Defines constants and methods related to configuration
  module Configuration
    include WrAPI::Configuration

    # An array of additional valid keys in the options hash when configuring a {Sophos::API}
    VALID_OPTIONS_KEYS = (WrAPI::Configuration::VALID_OPTIONS_KEYS + [:partner_id, :tenant_id, :id_endpoint]).freeze

    # @private
    attr_accessor *VALID_OPTIONS_KEYS

    # Reset all configuration options to defaults
    def reset
      super
      self.partner_id = nil
    end
  end
end

