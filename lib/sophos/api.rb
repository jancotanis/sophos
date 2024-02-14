require "wrapi"
require File.expand_path('configuration', __dir__)
require File.expand_path('authentication', __dir__)

module Sophos
  # @private
  
  class API
    # @private
    attr_accessor *Configuration::VALID_OPTIONS_KEYS

    # Creates a new API and copies settings from singleton
    def initialize(options = {})
      options = Sophos.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    def config
      conf = {}
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        conf[key] = send key
      end
      conf
    end

    include Configuration
    include WrAPI::Connection
    include WrAPI::Request
    include Authentication
  end
end
