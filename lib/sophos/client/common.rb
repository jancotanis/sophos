# frozen_string_literal: true

module Sophos
  class Client
    require File.expand_path('helper', __dir__)
    include Sophos::Client::Helper

    # Common API module for handling various endpoints in Sophos Central.
    # This module provides access to alerts, directory users, and user groups.
    # @see https://developer.sophos.com/docs/common-v1/1/overview
    module Common
      # Define API calls using helper methods for common endpoints.
      # These methods automatically create GET calls to the specified URL.
      #
      # @see https://developer.sophos.com/docs/common-v1/1/routes/alerts/get
      Helper::def_api_call :alerts, Helper::common_url(:alerts)

      # @see https://developer.sophos.com/docs/common-v1/1/routes/directory/user-groups/get
      Helper::def_api_call :directory_user_groups, Helper::common_url('directory/user-groups')

      # Fetch paginated users in a specified user group.
      # @param group_id [String] The ID of the user group.
      # @param params [Hash] Additional query parameters (e.g., `pageSize`, `page`).
      # @return [Hash] API response containing users in the specified group.
      # @see https://developer.sophos.com/docs/common-v1/1/routes/directory/user-groups/get
      def directory_user_group_users(group_id, params = {})
        get_paged(Helper::common_url("directory/user-groups/#{group_id}/users"), params)
      end

      # Define an API call to fetch all directory users.
      # @see https://developer.sophos.com/docs/common-v1/1/routes/directory/users/get
      Helper::def_api_call :directory_users, Helper::common_url('directory/users')

      # Fetch paginated user groups for a specified user.
      # @param user_id [String] The ID of the user.
      # @param params [Hash] Additional query parameters (e.g., `pageSize`, `page`).
      # @return [Hash] API response containing groups the user belongs to.
      # @see https://developer.sophos.com/docs/common-v1/1/routes/directory/users/get
      def directory_user_groups(user_id, params = {})
        get_paged(Helper::common_url("directory/users/#{user_id}/groups"), params)
      end

      # Additional methods for roles and admins can be retrieved using the partner API.
    end
  end
end
