module Sophos
  class Client
    require File.expand_path('helper', __dir__)
    include Sophos::Client::Helper

    # Sophos partner api
    # @see https://developer.sophos.com/docs/partner-v1/1/overview
    module Partner

      def self.__def_partner_call(method, id_field = nil)
        if id_field
          self.send(:define_method, method) do |id = nil|
            url = partner_url(method)
            if id
              get(partner_url("#{method}/#{id}"))
            else
              get_paged(url)
            end
          end
          # strip trailing 's'
          singular = method.to_s.chop.to_sym
          self.send(:define_method, singular) do |id, params = nil|
            get(partner_url("#{method}/#{id}", params))
          end
        else
          self.send(:define_method, method) do
            get_paged(partner_url(method))
          end
        end
      end

      # @see https://developer.sophos.com/docs/partner-v1/1/routes/tenants/get
      Helper::def_api_call :tenants, Helper::partner_url(:tenants), true

      # @see https://developer.sophos.com/docs/partner-v1/1/routes/roles/get
      Helper::def_api_call :roles, Helper::partner_url(:roles), true

      # @see https://developer.sophos.com/docs/partner-v1/1/routes/admins/get
      Helper::def_api_call :admins, Helper::partner_url(:admins), true

      # Get the list of role assignments for given admin.
      # @see https://developer.sophos.com/docs/partner-v1/1/routes/admins/%7BadminId%7D/role-assignments/get
      def admin_role_assignments(admin_id, params = {})
        get(Helper::partner_url("admins/#{admin_id}/role-assignments"), params)
      end
      # Get the list of role assignments for given admin.
      # @see https://developer.sophos.com/docs/partner-v1/1/routes/admins/%7BadminId%7D/role-assignments/%7BassignmentId%7D/get
      def admin_role_assignment(admin_id, assignment_id, params = {})
        get(Helper::partner_url("admins/#{admin_id}/role-assignments/#{assignment_id}"), params)
      end


      # List all the tenants for a partner
      def permission_sets( params = {} )
        get(Helper::partner_url('roles/permission-sets'), params)
      end

      # Usage report.
      # @see https://developer.sophos.com/docs/partner-v1/1/routes/billing/usage/%7Byear%7D/%7Bmonth%7D/get
      def billing_usage(year, month, params = {})
        get_paged(Helper::partner_url("billing/usage/#{year}/#{month}"), params)
      end

    private

      def __partner_url(method, id = nil)
        "/partner/v1/#{method}"
      end
    end
  end
end
