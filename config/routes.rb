# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
  devise_for :users

  namespace :api, defaults: { format: :json }, constraints: { subdoamin: 'api' }, path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: %i[show create update destroy]
      resources :sessions, only: %i[create destroy]
      resources :products, only: %i[show]
    end
  end
end
