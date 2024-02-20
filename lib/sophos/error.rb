module Sophos
	
  # Generic error to be able to rescue all Zabbix errors
  class SophosError < StandardError; end

  # Raised when Zabbix not configured correctly
  class ConfigurationError < SophosError; end

  # Error when authentication fails
  class AuthenticationError < SophosError; end
end