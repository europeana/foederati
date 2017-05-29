# frozen_string_literal: true
module Foederati
  ##
  # A Foederati provider is one JSON API provider capable of being searched by
  # the Foederati.
  #
  # TODO allow specification of a wildcard to search all the provider's records
  class Provider
    autoload :Request, 'foederati/provider/request'
    autoload :Response, 'foederati/provider/response'

    # TODO validate the type of values added to these
    Urls = Struct.new(:api, :site, :logo)
    Results = Struct.new(:items, :total)
    Fields = Struct.new(:title, :thumbnail, :url)

    attr_reader :id, :urls, :results, :fields, :display_name

    def initialize(id, &block)
      @id = id
      @urls = Urls.new
      @results = Results.new
      @fields = Fields.new
      @display_name = ''

      instance_eval(&block) if block_given?

      self
    end

    # TODO sanity check things like presence of API URL
    def search(**params)
      request.execute(params).normalise
    end

    protected

    def request
      Request.new(self)
    end
  end
end
