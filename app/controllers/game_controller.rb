class GameController < ApplicationController

  def index
  end

  def new
  end

  def create
    @game = Game.create
  end

  def show
    @game = Game.find(params[:id])
    @player_cards = @game.cards_for @player
    @table_cards  = @game.cards_on_table
  end

  def change
    @game = Game.find(params[:id])
  end
end
