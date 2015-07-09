class PlayersController < ApplicationController

  def index
    @player = Player.order(:bankroll, :desc).limit(10)
  end

  def create
    @player = Player.create(name: params[:name])
  end

  def change
    @player = Player.find params[:id]
  end
end
