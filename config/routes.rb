Rails.application.routes.draw do

  root 'game#index'
  post 'game' => 'game#create'
  patch 'game/:id' => 'game#change'

  get 'players' => 'players#index'
  post 'players' => 'players#create'
  patch 'players/:id' => 'players#change'
  get 'token/:token' => 'players#token'
end
