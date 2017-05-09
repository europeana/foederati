# frozen_string_literal: true
module Foederati
  autoload :Provider, 'foederati/provider'
  autoload :Providers, 'foederati/providers'

  class << self
    def search(id, **params)
      Providers.get(id).search(params)
    end
  end
end

# TODO something nicer than this
Dir.glob(File.expand_path('../foederati/providers/*.rb', __FILE__)).each do |file|
  require file
end
