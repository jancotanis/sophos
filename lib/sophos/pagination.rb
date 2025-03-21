# frozen_string_literal: true

require 'json'

module Sophos
  # Defines HTTP request methods
  # required attributes format
  module RequestPagination
    # Defines HTTP request pagination logic for Sophos APIs.
    # Sophos supports different pagination approaches for the global API and tenant APIs.
    #
    # Expected response structure:
    # {
    #   "pages": {
    #     "current": 1,   # Current page number (optional)
    #     "size": 50,     # Items per page
    #     "total": 3,     # Total pages (optional)
    #     "items": 123,   # Total items (optional)
    #     "maxSize": 100, # Maximum items per page allowed (optional)
    #     "nextKey": "abc123" # Key for fetching the next page, used when available
    #   },
    #   "items": []        # Array of data items for the current page
    # }
    class PagesPagination
      attr_reader :current, :total, :page_size

      def initialize(page_size)
        @page_size = page_size
        @total = 1       # Default total pages
        @current = 1     # Start at the first page
        @next_key = nil  # Key for fetching the next page if provided by the API
      end

      # Returns options to be passed as query parameters for the next API request.
      def page_options
        options = { page: @current, pageSize: @page_size, pageTotal: true }
        options[:pageFromKey] = @next_key if @current > 1 && @next_key # wellicht nil zetten zonder && @next_key?
        options
      end

      # Updates the pagination state based on the API response data.
      def next_page!(data)
        pages = page_info(data)
        if pages
          set_page_state(pages)
        else
          # Assume a single-page request if no pagination info is available.
          @total = 0
        end
      end

      # Extracts the 'pages' metadata from the response body.
      def page_info(body)
        body['pages']
      end

      # Extracts the relevant data items from the API response.
      def self.data(body)
        body['items'] || body
      end

      # Returns true if more pages are available.
      def more_pages?
        @current <= @total
      end

      private

      # Updates the current page, total pages, and next key (if present) from the pages metadata.
      def set_page_state(pages)
        @total = pages['total'].to_i if pages['total']
        @current = pages['current'] ? pages['current'].to_i + 1 : @current + 1
        @next_key = pages['nextKey'] if pages['nextKey']
      end
    end
  end
end
