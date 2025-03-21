# frozen_string_literal: true

module Sophos
  # Wrapper for the Sophos Central REST API.
  #
  # This class acts as the main client for interacting with Sophos APIs and provides
  # methods to create specific clients for tenants.
  #
  # @note All methods are separated into modules based on the Sophos API documentation structure.
  # @see https://developer.sophos.com/getting-started
  class Client < API
    require File.expand_path('client/partner', __dir__)

    # Returns a tenant-specific client to access the API host for the given tenant.
    #
    # @param tenant [Hash] The tenant object containing API host and tenant ID.
    # @return [TenantClient, nil] A configured tenant client, or nil if the tenant is not provided.
    #
    # @example Access tenant-specific APIs:
    #   tenant_client = client(tenant)
    #   tenant_client.some_tenant_specific_api_call
    def client(tenant)
      tenant_client(tenant.apiHost, tenant.id) if tenant
    end

    # Returns a configured tenant client to access APIs for a specific tenant ID and API host.
    #
    # @param api_host [String] The API host for the tenant.
    # @param tenant_id [String] The tenant's unique ID.
    # @return [TenantClient] A client configured with the tenant's API endpoint and headers.
    #
    # @example Create a tenant client and access tenant data:
    #   api_host = tenant.apiHost
    #   tenant_id = tenant.id
    #   tenant_client = tenant_client(api_host, tenant_id)
    def tenant_client(api_host, tenant_id)
      TenantClient.new(
        self.config.merge(
          {
            access_token: access_token,
            endpoint: api_host,
            tenant_id: tenant_id,
            connection_options: { headers: { 'X-Tenant-ID': tenant_id } }
          }
        )
      )
    end

    # Includes partner-related API methods.
    include Sophos::Client::Partner
  end

  # Wrapper for the Sophos Central REST API for tenant-related calls.
  #
  # This class inherits from `Sophos::Client` and includes additional modules
  # for tenant-specific endpoints and common API methods.
  #
  # @note All tenant methods are separated into modules based on the Sophos API documentation.
  # @see https://developer.sophos.com/getting-started
  class TenantClient < Client
    require File.expand_path('client/common', __dir__)
    require File.expand_path('client/endpoint', __dir__)

    # Includes modules for tenant-related and common API endpoints.
    include Sophos::Client::Common
    include Sophos::Client::Endpoint
  end
end
