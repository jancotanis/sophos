# frozen_string_literal: true

module Sophos
  # Base class for all custom errors in the Sophos module.
  # Allows rescuing all Sophos-related exceptions with a single error class.
  class SophosError < StandardError; end

  # Raised when configuration is incomplete or invalid.
  class ConfigurationError < SophosError; end

  # Raised when authentication to the Sophos API fails.
  class AuthenticationError < SophosError; end

  # Raised when API requests encounter general HTTP-related errors (optional future usage).
  # Uncomment or extend if needed.
  # class ApiError < SophosError; end
end
