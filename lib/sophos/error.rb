module Sophos
	
  # Generic error to be able to rescue all Sophos errors
  class SophosError < StandardError; end

  # Raised when Sophos not configured correctly
  class ConfigurationError < SophosError; end

  # Error when authentication fails
  class AuthenticationError < SophosError; end
end