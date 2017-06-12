# frozen_string_literal: true
module Foederati
  class Provider
    ##
    # Makes HTTP requests to provider APIs.
    #
    # Used by `Foederati::Provider#search`.
    class Request
      attr_reader :provider

      delegate :id, :urls, to: :provider
      delegate :connection, to: Foederati

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
        { api_key: Foederati.api_keys.send(id) }.
          merge(Foederati.defaults.to_h).
          merge(provider.default_params.to_h)
      end

      ##
      # Construct the URL for making an API request
      #
      # @param params [Hash] query-specific URL parameters
      # @return [String] the provider's API URL with all necessary params
      def api_url(**params)
        local_params = params.dup
        local_params.delete(:query) if local_params[:query].blank? && provider.default_params.query.present?
        format(urls.api, default_params.merge(local_params))
      end
    end
  end
end
