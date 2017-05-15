# frozen_string_literal: true
module Foederati
  class DocumentsController < ActionController::Base
    # Searches a Foederati provider
    #
    # Provider is identifier by `provider_id` param in the URL path, e.g.
    # given a provider "online_library", /foederati/online_library
    #
    # Other parameters:
    # * `q`: query
    # * `l`: limit (number of results to request & return)
    #
    # Responds with Foederati JSON results.
    #
    # TODO make the incoming parameter keys configurable for the host Rails app
    def index
      respond_to do |format|
        format.json do
          render json: Foederati.search(params[:provider_id], **provider_search_params)
        end
      end
    end

    protected

    def provider_search_params
      {
        query: params[:q]
      }.tap do |provider_params|
        provider_params[:limit] = params[:l] if params.key?(:l)
      end
    end
  end
end
