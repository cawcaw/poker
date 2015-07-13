Rails.application.routes.draw do

  root 'game#index'
  post 'game' => 'game#create',            as: :create_game
  get  'game/:id' => 'game#show',          as: :game
  post 'game/:id' => 'game#change',        as: :game_turn
  get  'new' => 'game#new',                as: :new_game
  post 'game/:id/join' => 'game#join',     as: :join_game
  get  'game/:id/stream' => 'game#stream', as: :stream

  get  'players' => 'players#index'
  post 'players' => 'players#create'
  post 'players/:id' => 'players#change'
  get  'token/:token' => 'players#token'
end
