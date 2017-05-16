# frozen_string_literal: true
require 'faraday_middleware/response_middleware'

module Foederati
  module FaradayMiddleware
    ##
    # Response handler for unspported content types returned by provider APIs
    #
    # For instance, if upstream APIs break and start returning HTML or text from
    # load balancers.
    class ParseUnsupportedContentTypes < ::FaradayMiddleware::ResponseMiddleware
      def process_response(env)
        super
        content_type = env.response_headers['Content-Type']
        fail Faraday::ParsingError,
             %(API responded with Content-Type "#{content_type}" and status #{env[:status]})
      end
    end

    Faraday::Response.register_middleware unsupported: -> { ParseUnsupportedContentTypes }
  end
end
