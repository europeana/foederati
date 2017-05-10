# frozen_string_literal: true
require 'faraday'
require 'faraday_middleware'
require 'typhoeus/adapters/faraday'

module Foederati
  class Provider
    ##
    # Makes HTTP requests to provider APIs.
    #
    # Used by `Foederati::Provider#search`.
    class Request
      attr_reader :provider

      delegate :id, :urls, to: :provider

      # @param provider [Foederati::Provider] the provider to make an API request for
      def initialize(provider)
        @provider = provider
      end

      ##
      # Executes a query against the provider's API
      #
      # @param params [Hash] query-specific URL parameters
      # @return [Foederati::Response] response from the API
      def execute(**params)
        faraday_response = connection.get(api_url(params))
        Response.new(provider, faraday_response)
      end

      ##
      # Default parameters to add to query-specific ones when querying the
      # provider's API.
      #
      # For instance, API key and limit.
      #
      # @return [Hash]
      def default_params
        { api_key: Foederati.api_keys.send(id) }.merge(Foederati.defaults.to_h)
      end

      ##
      # Construct the URL for making an API request
      #
      # @param params [Hash] query-specific URL parameters
      # @return [String] the provider's API URL with all necessary params
      def api_url(**params)
        format(urls.api, default_params.merge(params))
      end

      ##
      # `Faraday` connection for executing HTTP requests
      #
      # @return [Faraday::Connection]
      def connection
        @connection ||= begin
          Faraday.new do |conn|
            # TODO are max: 5 and interval: 3 sensible values? should they be
            #   made configurable?
            conn.request :retry, max: 5, interval: 3,
                                 exceptions: [Errno::ECONNREFUSED, Errno::ETIMEDOUT, 'Timeout::Error',
                                              Faraday::Error::TimeoutError, EOFError]

            conn.response :json, content_type: /\bjson$/

            conn.adapter :typhoeus
          end
        end
      end
    end
  end
end
