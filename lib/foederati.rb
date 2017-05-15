# frozen_string_literal: true
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/blank'
require 'active_support/hash_with_indifferent_access'
require 'ostruct'

require 'foederati/engine' if defined?(Rails)

# TODO add logger
module Foederati
  autoload :Provider, 'foederati/provider'
  autoload :Providers, 'foederati/providers'

  Defaults = Struct.new(:limit)

  class << self
    def configure(&block)
      instance_eval(&block)
      self
    end

    def api_keys
      @api_keys ||= OpenStruct.new
    end

    def defaults
      @defaults ||= Defaults.new
    end

    ##
    # Search registered providers
    #
    # @param ids [Symbol] ID(s) of one or more provider to search
    # @param params [Hash] search query parameters
    # @return [Hash] combined results of all providers
    # TODO run multiple searches in parallel
    def search(*ids, **params)
      ids.map do |id|
        Providers.get(id).search(params)
      end.reduce(&:merge)
    end
  end
end

# TODO something nicer than this
Dir.glob(File.expand_path('../foederati/providers/*.rb', __FILE__)).each do |file|
  require file
end
