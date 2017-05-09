# frozen_string_literal: true
module Foederati
  class Providers
    @registry = {}

    class << self
      attr_reader :registry

      ##
      # Register a provider
      #
      # @param id [Symbol] unique identifier for the provider
      def register(id, &block)
        registry[id] = Provider.new(&block)
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
