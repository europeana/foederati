# frozen_string_literal: true
module Foederati
  ##
  # All providers known to Foederati
  class Providers
    @registry = HashWithIndifferentAccess.new

    class << self
      attr_reader :registry

      ##
      # Register a provider
      #
      # @param id_or_provider [Symbol,Foederati::Provider] identifier of a new
      #   provider, or an instantiated provider
      def register(id_or_provider, &block)
        case id_or_provider
        when Foederati::Provider
          registry[id_or_provider.id] = id_or_provider
        when Symbol
          registry[id_or_provider] = Provider.new(id_or_provider, &block)
        else
          fail ArgumentError, "Expected Symbol or Foederati::Provider, got #{id_or_provider.class}"
        end
      end

      ##
      # Unregisters a provider
      #
      # @param id [Symbol] unique identifier of the provider
      # @param provider [Foederati::Provider] provider removed from the registry
      def unregister(id)
        registry.delete(id)
      end

      ##
      # Get a provider from the registry
      #
      # @param id [Symbol] identifier of the provider to get
      # @return [Foederati::Provider]
      def get(id)
        registry[id]
      end
    end
  end
end
