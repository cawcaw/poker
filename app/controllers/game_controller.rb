class GameController < ApplicationController
  include ActionController::Live

  def index
  end

  def new
  end

  def create
    @game = Game.create({ live: true })
    if params[:versus] == 'ai'
      params[:amount].times do
        @game.add_ai_hand 500
      end
    end
    @game.add_hand @player, 500

    redirect_to action: :show, id: @game.id
  end

  def show
    @game = Game.find(params[:id])
  end

  def join
    @game = Game.find(params[:id])
    @game.add_hand @player, 500
    redirect_to :back
  end

  def change
    @game = Game.find(params[:id])
    redirect_to :back
  end

  def stream
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream)
    begin
      p "stream established"
      ActiveSupport::Notifications.subscribe("game_turn") do |*args|
        sse.write("rerender!")
      end
    rescue IOError
    ensure
      sse.close
    end
    render nothing: true
  end
end
