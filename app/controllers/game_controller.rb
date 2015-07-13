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
    p params[:turn]
    case params[:turn]
    when 'bet'
      bet_diff = @game.bet - @game.hand_of(@player).bet
      if bet_diff == 0
        bet_diff = 20
        @game.set_bet @game.bet + bet_diff
      end
      @game.make_bet(@player, bet_diff)
      @game.make_check(@player)
    when 'raise'
      @game.make_bet(@player, 40)
      @hame.uncheck_all
      @game.make_check(@player)
      @game.set_bet @game.bet + 40
    when 'check'
      @game.make_check(@player)
    end
    Game.connection.execute "NOTIFY game, 'change'"
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
    ensure
      sse.close
    end
    render nothing: true
  end
end
