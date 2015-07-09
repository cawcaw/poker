class PlayersController < ApplicationController

  def index
    @player = Player.order(:bankroll, :desc).limit(10)
  end

  def create
    @player = Player.create(name: params[:name])
    render :setup_cookies
  end

  def change
    @player = Player.find params[:id]
  end

  def token
    if !@player && @player = Player.find_by_token(params[:token])
      render :setup_cookies
    else
      redirect_to :root
    end
  end
end
