# frozen_string_literal: true
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/blank'
require 'ostruct'

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

    def search(id, **params)
      Providers.get(id).search(params)
    end
  end
end

# TODO something nicer than this
Dir.glob(File.expand_path('../foederati/providers/*.rb', __FILE__)).each do |file|
  require file
end
