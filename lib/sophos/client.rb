

module Sophos

  # Wrapper for the Sophos Central REST API
  #
  # @note All methods have been separated into modules and follow the same grouping used in api docs
  # @see https://developer.sophos.com/getting-started
  class Client < API
    require File.expand_path('client/partner', __dir__)

    # get client to access api host for given tenant
    # @return [TenantClient]
    def client(tenant)
      tenant_client(tenant.apiHost, tenant.id) if tenant
    end

    # get teannt client to access api host for given tenant id
    # @return [TenantClient]
    def tenant_client( api_host, tenant_id )
      # create client and copy access_token and set default headers
      TenantClient.new(self.config.merge({
        access_token: access_token,
        endpoint: api_host,
        tenant_id: tenant_id,
        connection_options: { headers: { 'X-Tenant-ID': tenant_id } }
      }))
    end

    include Sophos::Client::Partner
  end

  # Wrapper for the Sophos Central REST API for tenant related calls
  #
  # @note All methods have been separated into modules and follow the same grouping used in api docs
  # @see https://developer.sophos.com/getting-started
  class TenantClient < Client
    require File.expand_path('client/common', __dir__)
    require File.expand_path('client/endpoint', __dir__)
    include Sophos::Client::Common
    include Sophos::Client::Endpoint
  end
end
