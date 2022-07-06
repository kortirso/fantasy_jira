# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :users do
    get 'sign_up', to: 'registrations#new'
    post 'sign_up', to: 'registrations#create'

    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    get 'logout', to: 'sessions#destroy'
  end

  resources :tasks, only: %i[index create update] do
    resource :approvements, only: %i[create], module: 'tasks'
  end
  namespace :tasks do
    resources :approvements, only: %i[index]
  end

  root 'welcome#index'
end
