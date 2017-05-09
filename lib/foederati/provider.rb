# frozen_string_literal: true
require 'faraday'
require 'faraday_middleware'
require 'typhoeus/adapters/faraday'

module Foederati
  class Provider
    Urls = Struct.new(:api, :site)
    Results = Struct.new(:items, :total)
    Fields = Struct.new(:title, :thumbnail, :url)

    attr_accessor :urls, :results, :fields

    def initialize(&block)
      @urls = Urls.new
      @results = Results.new
      @fields = Fields.new
      instance_eval(&block) if block_given?
    end

    # TODO move this to a separate `Search` class?
    def connection
      @connection ||= begin
        Faraday.new do |conn|
          conn.request :retry, max: 5, interval: 3,
                               exceptions: [Errno::ECONNREFUSED, Errno::ETIMEDOUT, 'Timeout::Error',
                                            Faraday::Error::TimeoutError, EOFError]

          conn.response :json, content_type: /\bjson$/

          conn.adapter :typhoeus
        end
      end
    end

    def search(**params)
      connection.get(format(urls.api, params))
    end
  end
end
