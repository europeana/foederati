# frozen_string_literal: true
module Foederati
  class DocumentsController < ActionController::Base
    protect_from_forgery

    class ProviderNotSpecifiedError < StandardError; end

    rescue_from ProviderNotSpecifiedError do
      render json: { error: 'Provider must be specified.' }, status: 400
    end

    # Searches a Foederati provider
    #
    # Provider is identified either by `provider_id` param in the URL path, e.g.
    # given a provider "online_library", /foederati/online_library, or if
    # accessed at /foederati, by `p` parameter which may contain multiple
    # comma-separated provider IDs
    #
    # Other parameters:
    # * `q`: search query terms
    # * `l`: limit (number of results to request & return)
    #
    # Responds with Foederati JSON results.
    #
    # TODO make the incoming parameter keys configurable for the host Rails app
    def index
      render json: Foederati.search(*provider_ids, **provider_search_params)
    end

    protected

    def provider_search_params
      {
        query: params[:q]
      }.tap do |provider_params|
        provider_params[:limit] = params[:l] if params.key?(:l)
      end
    end

    def provider_ids
      if params[:provider_id].present?
        params[:provider_id]
      elsif params[:p].present?
        params[:p].split(',')
      else
        fail ProviderNotSpecifiedError
      end
    end
  end
end
