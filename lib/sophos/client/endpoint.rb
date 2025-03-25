# frozen_string_literal: true

module Sophos
  class Client
    require File.expand_path('helper', __dir__)
    include Sophos::Client::Helper

    # Module to interact with Sophos Endpoint API
    # @see https://developer.sophos.com/docs/endpoint-v1/1/overview
    module Endpoint
      # Define API calls with dynamic helper methods for common endpoints.

      # Fetch available software downloads.
      # @see https://developer.sophos.com/docs/endpoint-v1/1/routes/downloads/get
      Helper::def_api_call :downloads, Helper::endpoint_url(:downloads)

      # Fetch all endpoint groups.
      # @see https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoint-groups/get
      Helper::def_api_call :endpoint_groups, Helper::endpoint_url(:endpoint_groups), :endpoint_group

      # Fetch endpoints belonging to a specific endpoint group.
      # @param group_id [String] The ID of the endpoint group.
      # @return [Array<Hash>] Paginated response with endpoint details.
      def endpoint_group_endpoints(group_id)
        get_paged Helper::endpoint_url("endpoint-groups/#{group_id}/endpoints")
      end

      # Fetch details on endpoint migrations.
      # @see https://developer.sophos.com/docs/endpoint-v1/1/routes/migrations/get
      Helper::def_api_call :migrations, Helper::endpoint_url(:migrations), :migration

      # Fetch endpoints involved in a specific migration.
      # @param migration_id [String] The ID of the migration.
      # @return [Array<Hash>] Paginated response with endpoints involved in the migration.
      def migration_endpoints(migration_id)
        get_paged Helper::endpoint_url("migrations/#{migration_id}/endpoints")
      end

      # Fetch policy details for the tenant.
      # @see https://developer.sophos.com/docs/endpoint-v1/1/routes/policies/get
      Helper::def_api_call :policies, Helper::endpoint_url(:policies), :policy

      # Fetch all endpoints for the specified tenant.
      # @note No specific `endpoint` method due to potential name conflicts with the base API method.
      # @see https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/get
      Helper::def_api_call :endpoints, Helper::endpoint_url(:endpoints)

      # Fetch the isolation status for a specific endpoint.
      # @param endpoint_id [String] The ID of the endpoint.
      # @return [Hash] Response with the isolation status of the endpoint.
      # @see https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/get
      def endpoint_isolation(endpoint_id)
        get Helper::endpoint_url("endpoints/#{endpoint_id}/isolation")
      end

      # Fetch tamper protection settings for a specific endpoint.
      # @param endpoint_id [String] The ID of the endpoint.
      # @return [Hash] Response containing tamper protection details.
      # @see https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/get
      def endpoint_tamper_protection(endpoint_id)
        get Helper::endpoint_url("endpoints/#{endpoint_id}/tamper-protection")
      end
    end
  end
end
