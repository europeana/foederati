# frozen_string_literal: true
Foederati::Engine.routes.draw do
  get '/:provider_id', to: 'documents#index'
end
