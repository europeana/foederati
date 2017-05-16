# frozen_string_literal: true
module Foederati
  class Provider
    ##
    # Contains a response from a request to a provider's API
    #
    # Returned by `Foederati::Provider::Request#execute`.
    class Response
      attr_reader :provider, :faraday_response

      delegate :body, to: :faraday_response
      delegate :results, :fields, :id, to: :provider

      # @param provider [Foederati::Provider] provider the API response is for
      # @param faraday_response [Faraday::Response] Faraday response object
      def initialize(provider, faraday_response)
        @provider = provider
        @faraday_response = faraday_response
      end

      ##
      # Normalises response from provider's API
      #
      # @return [Hash]
      def normalise
        {
          id => {
            total: fetch_from_response(results.total, body) || 0,
            results: items_from_response.map do |item|
              {
                title: fetch_from_response(fields.title, item),
                thumbnail: fetch_from_response(fields.thumbnail, item),
                url: fetch_from_response(fields.url, item)
              }
            end
          }
        }
      end
      alias_method :to_h, :normalise

      protected

      ##
      # Gets the set of items from the response body
      #
      # @return [Array]
      def items_from_response
        fetch_from_response(results.items, body) || []
      end

      ##
      # Fetch a field from part of the provider's JSON response
      #
      # @param field `Proc` to call with `hash`, else keys to pass to `#fetch_deep`
      # @param hash [Hash] (part of) the JSON response hash
      def fetch_from_response(field, hash)
        if field.blank?
          nil
        elsif field.respond_to?(:call)
          field.call(hash)
        else
          fetch_deep(field, hash)
        end
      end

      ##
      # Digs down into a nested hash to get the value beneath multiple keys
      #
      # @example
      #   fetch_deep(%i(a b), { a: { b: 'c' } }) #=> 'c'
      #
      # @param keys one or more keys to fetch from the hash
      # @param hash [Hash] the hash to fetch deep from
      def fetch_deep(keys, hash)
        return hash unless hash.is_a?(Hash)

        local_keys = [keys.dup].flatten
        return hash if local_keys.blank?

        key = local_keys.shift
        fetch_deep(local_keys, hash[key])
      end
    end
  end
end
