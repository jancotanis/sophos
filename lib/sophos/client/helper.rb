module Sophos
  
  # Generate generic api methods
  class Client
    module Helper

      def self.sanitize method_name
        method_name.to_s.gsub('_', '-')
      end

      def self.common_url(method) self.url('common', method); end
      def self.endpoint_url(method) self.url('endpoint', method); end
      def self.partner_url(method) self.url('partner', method); end
      
      def self.url(api,method)
        "/#{api}/v1/#{sanitize(method)}"
      end

      # generate end point for 'endpoint' and 'endpoints'
      def self.def_api_call(method, url, singular_method = nil, paged = true)
        if singular_method
          self.singular_method(method,url,singular_method)
        else
          if paged
            self.paged_method(method,url)
          else
            self.plain_method(method,url)
          end
        end
      end
      
      def self.singular_method(method,url,singular_method)
        self.send(:define_method, method) do |id = nil, params = {}|
          if id
            get("#{url}/#{id}", params)
          else
            get_paged(url, params)
          end
        end
        # strip trailing 's'
        self.send(:define_method, singular_method) do |id, params = {}|
          get("#{url}/#{id}", params)
        end
      end
      def self.paged_method(method,url)
        self.send(:define_method, method) do |params = {}|
          get_paged(url, params)
        end
      end
      def self.plain_method(method,url)
        self.send(:define_method, method) do |params = {}|
          get(url, params)
        end
      end

    end
  end

end
