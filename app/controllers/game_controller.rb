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
    Game.connection.execute "NOTIFY game, 'join'"
    redirect_to :back
  end

  def change
    @game = Game.find(params[:id])
    case params[:]
    redirect_to :back
  end

  def stream
    @game = Game.find(params[:id])
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream)
    begin
      @game.on_change do |data|
        sse.write(data)
      end
    rescue IOError
    # Client Disconnected
    ensure
      sse.close
    end
    render nothing: true
  end
end
