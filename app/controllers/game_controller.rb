class GameController < ApplicationController
  def index
    @games = Game.where live: true
  end

  def create
    Game.create
  end

  def update
    @game = Game.find params[:id]
  end
end