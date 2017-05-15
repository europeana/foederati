# frozen_string_literal: true
Foederati::Engine.routes.draw do
  root to: 'documents#index'
  get '/:provider_id', to: 'documents#index'
end
