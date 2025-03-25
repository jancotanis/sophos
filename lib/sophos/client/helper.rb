# frozen_string_literal: true

module Sophos
  # This module provides helper methods to dynamically define API calls for the Sophos Client.
  # It supports paginated and non-paginated API methods, and allows generating
  # URLs for different API types (`common`, `endpoint`, `partner`).
  #
  # == Example:
  #
  #   # Define paginated API methods for fetching alerts:
  #   Helper::def_api_call(:alerts, Helper::common_url(:alerts), :alert)
  #
  #   # Generated methods:
  #   client.alerts        # Fetches paginated alerts
  #   client.alert(12345)  # Fetches a specific alert by ID (singular)
  #
  # @see https://developer.sophos.com/ Sophos API Documentation
  class Client
    module Helper
      # Converts method names to a URL-safe format by replacing underscores with hyphens.
      #
      # @param method_name [Symbol, String] The method name to sanitize.
      # @return [String] The sanitized method name (e.g., 'user_groups' => 'user-groups').
      #
      # == Example:
      #   sanitize(:user_groups) # => "user-groups"
      def self.sanitize(method_name)
        method_name.to_s.tr('_', '-')
      end

      # Generates a URL path for the common API.
      #
      # @param method [Symbol, String] The endpoint method name.
      # @return [String] Full path for the common API (e.g., `/common/v1/alerts`).
      #
      # == Example:
      #   common_url(:alerts) # => "/common/v1/alerts"
      def self.common_url(method)
        url('common', method)
      end

      # Generates a URL path for the endpoint API.
      #
      # @param method [Symbol, String] The endpoint method name.
      # @return [String] Full path for the endpoint API.
      #
      # == Example:
      #   endpoint_url(:downloads) # => "/endpoint/v1/downloads"
      def self.endpoint_url(method)
        url('endpoint', method)
      end

      # Generates a URL path for the partner API.
      #
      # @param method [Symbol, String] The endpoint method name.
      # @return [String] Full path for the partner API.
      #
      # == Example:
      #   partner_url(:tenants) # => "/partner/v1/tenants"
      def self.partner_url(method)
        url('partner', method)
      end

      # Constructs the full API URL path.
      #
      # @param api [String] API type (e.g., 'common', 'endpoint', 'partner').
      # @param method [Symbol, String] The sanitized endpoint method name.
      # @return [String] Full API URL path.
      #
      # == Example:
      #   url('common', :alerts) # => "/common/v1/alerts"
      def self.url(api, method)
        "/#{api}/v1/#{sanitize(method)}"
      end

      # Dynamically defines API methods for singular and plural endpoints.
      #
      # If `singular_method` is provided, it generates:
      # - A plural method for fetching all resources (e.g., `alerts`).
      # - A singular method for fetching a specific resource by ID (e.g., `alert(id)`).
      #
      # @param method [Symbol] The plural method name (e.g., `:alerts`).
      # @param url [String] The API endpoint URL path.
      # @param singular_method [Symbol, nil] The singular method name (optional).
      # @param paged [Boolean] Whether the method should support pagination (default: true).
      #
      # == Example:
      #   def_api_call(:alerts, "/common/v1/alerts", :alert)
      #
      #   # Generates:
      #   # - alerts(params = {}) – Fetches paginated alerts.
      #   # - alert(id, params = {}) – Fetches a specific alert by ID.
      #
      # @see define_singular_and_plural_methods, define_paged_method, define_plain_method
      def self.def_api_call(method, url, singular_method = nil, paged = true)
        if singular_method
          define_singular_and_plural_methods(method, url, singular_method)
        else
          paged ? define_paged_method(method, url) : define_plain_method(method, url)
        end
      end

      # Defines both singular and plural methods for API endpoints.
      #
      # - The plural method fetches either paginated resources or a single resource if an ID is passed.
      # - The singular method explicitly fetches a single resource by ID.
      #
      # @param method [Symbol] The plural method name (e.g., `:alerts`).
      # @param url [String] The API endpoint URL path.
      # @param singular_method [Symbol] The singular method name (e.g., `:alert`).
      #
      # == Example:
      #   define_singular_and_plural_methods(:alerts, "/common/v1/alerts", :alert)
      #
      #   # Generates:
      #   # - alerts(params = {}) – Fetches paginated alerts.
      #   # - alerts(id, params = {}) – Fetches a single alert by ID.
      #   # - alert(id, params = {}) – Fetches a single alert explicitly by ID.
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

      # Defines a paginated method for list-based API endpoints.
      #
      # @param method [Symbol] The method name (e.g., `:alerts`).
      # @param url [String] The API endpoint URL path.
      #
      # == Example:
      #   define_paged_method(:alerts, "/common/v1/alerts")
      #
      #   # Generates:
      #   # - alerts(params = {}) – Fetches paginated alerts.
      def self.define_paged_method(method, url)
        define_method(method) do |params = {}|
          get_paged(url, params)
        end
      end

      # Defines a simple, non-paginated API method.
      #
      # @param method [Symbol] The method name (e.g., `:roles`).
      # @param url [String] The API endpoint URL path.
      #
      # == Example:
      #   define_plain_method(:roles, "/partner/v1/roles")
      #
      #   # Generates:
      #   # - roles(params = {}) – Fetches roles without pagination.
      def self.define_plain_method(method, url)
        define_method(method) do |params = {}|
          get(url, params)
        end
      end
    end
  end
end
