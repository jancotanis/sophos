# frozen_string_literal: true

module Sophos
  class Client
    require File.expand_path('helper', __dir__)
    include Sophos::Client::Helper

    # Sophos Partner API module, providing access to tenants, roles, admins, and billing usage data.
    # @see https://developer.sophos.com/docs/partner-v1/1/overview
    module Partner
      # Retrieve a list of tenants or a single tenant by ID.
      # @see https://developer.sophos.com/docs/partner-v1/1/routes/tenants/get
      Helper::def_api_call :tenants, Helper::partner_url(:tenants), :tenant

      # Retrieve a list of roles or a single role by ID.
      # @see https://developer.sophos.com/docs/partner-v1/1/routes/roles/get
      Helper::def_api_call :roles, Helper::partner_url(:roles), :role

      # Retrieve a list of admins or a single admin by ID.
      # @see https://developer.sophos.com/docs/partner-v1/1/routes/admins/get
      Helper::def_api_call :admins, Helper::partner_url(:admins), :admin

      # Retrieve the role assignments for a given admin.
      # @param admin_id [String] Admin ID for whom role assignments are requested
      # @param params [Hash] Optional query parameters
      # @return [Hash] List of role assignments
      # @see https://developer.sophos.com/docs/partner-v1/1/routes/admins/%7BadminId%7D/role-assignments/get
      def admin_role_assignments(admin_id, params = {})
        get(Helper::partner_url("admins/#{admin_id}/role-assignments"), params)
      end

      # Retrieve a specific role assignment for an admin by assignment ID.
      # @param admin_id [String] Admin ID
      # @param assignment_id [String] Role assignment ID
      # @param params [Hash] Optional query parameters
      # @return [Hash] Details of the specific role assignment
      # @see https://developer.sophos.com/docs/partner-v1/1/routes/admins/%7BadminId%7D/role-assignments/%7BassignmentId%7D/get
      def admin_role_assignment(admin_id, assignment_id, params = {})
        get(Helper::partner_url("admins/#{admin_id}/role-assignments/#{assignment_id}"), params)
      end

      # Retrieve the list of permission sets.
      # @param params [Hash] Optional query parameters
      # @return [Array<Hash>] List of permission sets
      # @see https://developer.sophos.com/docs/partner-v1/1/routes/roles/permission-sets/get
      def permission_sets(params = {})
        get(Helper::partner_url('roles/permission-sets'), params)
      end

      # Retrieve the billing usage report for a specific year and month.
      # @param year [Integer] Year of the billing report (e.g., 2025)
      # @param month [Integer] Month of the billing report (e.g., 1 for January)
      # @param params [Hash] Optional query parameters
      # @return [Hash] Billing usage data for the specified month
      # @see https://developer.sophos.com/docs/partner-v1/1/routes/billing/usage/%7Byear%7D/%7Bmonth%7D/get
      def billing_usage(year, month, params = {})
        get_paged(Helper::partner_url("billing/usage/#{year}/#{month}"), params)
      end
    end
  end
end
