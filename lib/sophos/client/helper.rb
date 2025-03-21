# frozen_string_literal: true

module Sophos
  # Generate generic API methods dynamically for various Sophos APIs.
  class Client
    module Helper

      # Convert method names to URL-safe format (e.g., 'user_groups' => 'user-groups')
      # @param method_name [Symbol, String] Method name to be sanitized
      # @return [String] Sanitized method name for use in URL paths
      def self.sanitize(method_name)
        method_name.to_s.tr('_', '-')
      end

      # Generate a URL path for the common API
      # @param method [Symbol, String] Method name for the API endpoint
      # @return [String] Full path for the common API endpoint
      def self.common_url(method)
        url('common', method)
      end

      # Generate a URL path for the endpoint API
      def self.endpoint_url(method)
        url('endpoint', method)
      end

      # Generate a URL path for the partner API
      def self.partner_url(method)
        url('partner', method)
      end

      # Generic method to generate API URLs
      # @param api [String] API type (e.g., 'common', 'endpoint', 'partner')
      # @param method [Symbol, String] Endpoint method name
      # @return [String] Full API URL path
      def self.url(api, method)
        "/#{api}/v1/#{sanitize(method)}"
      end

      # Dynamically define API methods for both singular and plural endpoints.
      # It supports paginated or non-paginated responses.
      #
      # @param method [Symbol] Plural method name (e.g., `:alerts`)
      # @param url [String] Endpoint URL path
      # @param singular_method [Symbol, nil] Singular method name (e.g., `:alert`), optional
      # @param paged [Boolean] If true, generate paginated API calls (default: true)
      def self.def_api_call(method, url, singular_method = nil, paged = true)
        if singular_method
          define_singular_and_plural_methods(method, url, singular_method)
        else
          paged ? define_paged_method(method, url) : define_plain_method(method, url)
        end
      end

      private

      # Define both singular and plural methods.
      # Example: `alerts` (for paginated results) and `alert(id)` (for single alert).
      def self.define_singular_and_plural_methods(method, url, singular_method)
        # Define plural method: paginated call if no ID, otherwise fetch singular resource.
        define_method(method) do |id = nil, params = {}|
          id ? get("#{url}/#{id}", params) : get_paged(url, params)
        end

        # Define singular method explicitly for single resource retrieval.
        define_method(singular_method) do |id, params = {}|
          get("#{url}/#{id}", params)
        end
      end

      # Define a paginated method for list-based API endpoints.
      def self.define_paged_method(method, url)
        define_method(method) do |params = {}|
          get_paged(url, params)
        end
      end

      # Define a simple, non-paginated API method.
      def self.define_plain_method(method, url)
        define_method(method) do |params = {}|
          get(url, params)
        end
      end
    end
  end
end
