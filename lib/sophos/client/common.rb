module Sophos

  class Client
    require File.expand_path('helper', __dir__)
    include Sophos::Client::Helper

    # This is the OAS 3.0 specification for the Common API in Sophos Central.
    # @see https://developer.sophos.com/docs/common-v1/1/overview
    module Common

      # @see https://developer.sophos.com/docs/common-v1/1/routes/alerts/get
      Helper::def_api_call :alerts, Helper::common_url(:alerts)
      # @see https://developer.sophos.com/docs/common-v1/1/routes/directory/user-groups/get
      Helper::def_api_call :directory_user_groups, Helper::common_url('directory/user-groups')
      def directory_user_group_users(group_id, params = {})
        get_paged(Helper::common_url("directory/user-groups/#{group_id}/users"), params)
      end
      Helper::def_api_call :directory_users, Helper::common_url('directory/users')
      def directory_user_groups(user_id, params = {})
        get_paged(Helper::common_url("directory/users/#{user_id}/groups"), params)
      end
      # roles and admins can be retrieved using the partner api
    end
  end
end
