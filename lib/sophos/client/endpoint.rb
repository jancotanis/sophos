module Sophos
  class Client
    require File.expand_path('helper', __dir__)
    include Sophos::Client::Helper

    # Sophos Endpoint api
    # @see https://developer.sophos.com/docs/endpoint-v1/1/overview
    module Endpoint

      # @see https://developer.sophos.com/docs/endpoint-v1/1/routes/downloads/get
      Helper::def_api_call :downloads, Helper::endpoint_url(:downloads)

      # @see https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoint-groups/get
      Helper::def_api_call :endpoint_groups, Helper::endpoint_url(:endpoint_groups), true
      def endpoint_group_endpoints(group_id)
        get_paged Helper::endpoint_url("endpoint-groups/#{group_id}/endpoints")
      end

      # @see https://developer.sophos.com/docs/endpoint-v1/1/routes/migrations/get
      Helper::def_api_call :migrations, Helper::endpoint_url(:migrations), true
      def migration_endpoints(migration_id)
        get_paged Helper::endpoint_url("migrations/#{migration_id}/endpoints")
      end

      # @see https://developer.sophos.com/docs/endpoint-v1/1/routes/policies/get
      Helper::def_api_call :policies, Helper::endpoint_url(:policies), true

      # Get all the endpoints for the specified tenant. No endpoint method defined as this clashes with api endpoint method
      # @see https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/get
      Helper::def_api_call :endpoints, Helper::endpoint_url(:endpoints), false
      def endpoint_isolation(endpoint_id)
        get Helper::endpoint_url("endpoints/#{endpoint_id}/isolation")
      end
      def endpoint_tamper_protection(endpoint_id)
        get Helper::endpoint_url("endpoints/#{endpoint_id}/tamper-protection")
      end

    end
  end
end
