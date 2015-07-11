Rails.application.routes.draw do

  root 'game#index'
  post 'game' => 'game#create'
  patch 'game/:id' => 'game#show'
  patch 'game/:id' => 'game#change'
  get 'new' => 'game#new', as: :new_game

  get 'players' => 'players#index'
  post 'players' => 'players#create'
  patch 'players/:id' => 'players#change'
  get 'token/:token' => 'players#token'
end
