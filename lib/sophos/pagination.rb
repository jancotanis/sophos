require 'json'

module Sophos
  # Defines HTTP request methods
  # required attributes format
  module RequestPagination

    # Sophos uses different pagination for global api and tenant api
    #
    # response structure:
    # { "pages": {
    #     "current": 1, # page no - not laways present
    #     "size": 50,
    #     "total": 3,   # not always present - pages
    #     "items": 123, # not always present - records
    #     "maxSize": 100
    #   },
    # "items": []
    #
    class PagesPagination
      attr_reader :current, :total, :page_size

      def initialize(page_size)
        # ignore page size
        @page_size = page_size
        @total = @current = 1
      end

      def page_options
        { 'page': @current, 'pageSize': @page_size, 'pageTotal': true }
      end

      def next_page!(data)

        pages = page_info(data)
        if pages
          @total = pages['total'].to_i
          if pages['current']
            @current = pages['current'].to_i + 1
          else
            @current += 1
          end
        else
          # no page info so assume single page request
          @total = 0
        end
      end

      def page_info(body) 
        body['pages']
      end

      def self.data(body) 
        body['items'] ? body['items'] : body
      end

      # only single page available
      def more_pages?
        @current <= @total
      end
    end
  end
end
