require "wrapi"
require File.expand_path('sophos/api', __dir__)
require File.expand_path('sophos/client', __dir__)

module Sophos
  extend Configuration
  extend WrAPI::RespondTo

  #
  # @return [Sophos::Client]
  def self.client(options = {})
    Sophos::Client.new
  end
end
