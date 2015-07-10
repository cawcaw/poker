class GameController < ApplicationController

  def index
  end

  def new
  end

  def create
    @game = Game.create
  end

  def change
    @game = Game.find(params[:id])
  end
end
