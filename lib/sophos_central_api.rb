require "wrapi"
require File.expand_path('sophos/api', __dir__)
require File.expand_path('sophos/client', __dir__)
require File.expand_path('sophos/pagination', __dir__)
require File.expand_path('sophos/version', __dir__)

module Sophos
  extend Configuration
  extend WrAPI::RespondTo

  DEFAULT_ENDPOINT = 'https://api.central.sophos.com'.freeze
  DEFAULT_ID_ENDPOINT = 'https://id.sophos.com'.freeze
  DEFAULT_UA = "Sophos Ruby API wrapper #{Sophos::VERSION}".freeze
  DEFAULT_PAGINATION = Sophos::RequestPagination::PagesPagination
  DEFAULT_PAGE_SIZE = 100

  #
  # @return [Sophos::Client]
  def self.client(options = {})
    Sophos::Client.new({
      endpoint: DEFAULT_ENDPOINT,
      id_endpoint: DEFAULT_ID_ENDPOINT,
      user_agent: DEFAULT_UA,
      page_size: DEFAULT_PAGE_SIZE,
      pagination_class: DEFAULT_PAGINATION
    }.merge(options))
  end

  def self.reset
    super
    self.endpoint = DEFAULT_ENDPOINT
    self.id_endpoint = DEFAULT_ID_ENDPOINT
    self.user_agent = DEFAULT_UA
    self.page_size = DEFAULT_PAGE_SIZE
    self.pagination_class = DEFAULT_PAGINATION
  end
end
