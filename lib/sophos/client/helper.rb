module Sophos
  
  # Generate generic api methods
  class Client
    module Helper

      def self.sanitize method_name
        method_name.to_s.gsub('_', '-')
      end

      def self.singular method_name
        method_name = method_name.to_s.gsub(/s$/, '') 
        method_name.gsub(/ie$/, 'y').to_sym
      end

      def self.common_url(method)
        "/common/v1/#{sanitize(method)}"
      end

      def self.endpoint_url(method)
        "/endpoint/v1/#{sanitize(method)}"
      end

      def self.partner_url(method)
        "/partner/v1/#{sanitize(method)}"
      end

      # generate end point for 'endpoint' and 'endpoints'
      def self.def_api_call(method, url, id_field = false, paged = true)
        if id_field
          self.send(:define_method, method) do |id = nil, params = {}|
            if id
              get("#{url}/#{id}", params)
            else
              get_paged(url, params)
            end
          end
          # strip trailing 's'
          singlr = self.singular(method) #method.to_s.chop.to_sym
          self.send(:define_method, singlr) do |id, params = {}|
            get("#{url}/#{id}", params)
          end
        else
          if paged
            self.send(:define_method, method) do |params = {}|
              get_paged(url, params)
            end
          else
            self.send(:define_method, method) do |params = {}|
              get(url, params)
            end
          end
        end
      end

    end
  end

end
