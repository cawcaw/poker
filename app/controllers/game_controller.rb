class GameController < ApplicationController

  def index
    @games = Game.where(live: true)
  end

  def create
    @game = Game.create
  end

  def change
    @game = Game.find(params[:id])
  end
end
