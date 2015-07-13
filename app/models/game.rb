class Game < ActiveRecord::Base

  before_create { deck_state = 'd'*52 }

  # STREETS = [ ...
  # this way better then use constant
  def streets
    [[:preflop, -> { preflop(); uncheck_all() }],
     [:flop,    -> { cards_put_on_table(3); uncheck_all() }],
     [:turn,    -> { cards_put_on_table(1); uncheck_all() }],
     [:river,   -> { cards_put_on_table(1); uncheck_all() }]]
  end

  has_many :hands
  has_many :players, through: :hands

  # db notinited values fuse ///
  def street
    read_attribute(:street) || 0
  end
  # ////////////////////////////
  def bet
    read_attribute(:bet)    || 0
  end
  # ////////////////////////////
  def button
    read_attribute(:button) || 0
  end
  # ////////////////////////////

  def make_bet(player, summ)
    hand = hand_of(player)
    transaction do
      hand.update_attribute :stack, hand.stack - summ
      hand.update_attribute :bet, hand.bet + summ
    end
  end

  def make_check(player)
    hand_of(player).update_attribute :check, true
  end

  def check_check(player)
    hand_of(player).check
  end

  def uncheck_all
    hands.each do |hand|
      hand.update_attribute :check, false
    end
  end

  def set_bet(summ)
    update_attribute :bet, summ
  end

  def button_hand
    hands.where(number: button).first
  end

  def button_hand?(hand)
    hand.number == button
  end

  def next_street
    if streets[street]
      streets[street][1].call
      update_attribute :street, street + 1
    end
  end

  def free_place?
    hands.count < size
  end

  def all_in_place?
    hands.count == size
  end

  def all_in_place!
    update_attribute :size, hands.count
  end

  def in_game?(player)
    players.include?(player)
  end

  def add_hand(player, stack)
    if free_place?
      transaction do
        h = hands.create({ player_id: player.id, game_id: id, number: hands.count })
        player.update_attribute :bankroll, player.bankroll - stack
        h.stack = stack
      end
    end
    next_street if all_in_place?
    Game.connection.execute "NOTIFY game, 'add_hand'"
  end

  def add_ai_hand(stack)
    hands.create({ ai: true, game_id: id, number: hands.counts, stack: stack })
    next_street if all_in_place?
    Game.connection.execute "NOTIFY game, 'add_io_hand'"
  end

  def cards
    deck_state.try(:split, '') || ("d"*52).split('')
  end

  def cards_select(key)
    cards.each_index.select { |i| cards[i] == key.to_s }
  end

  def cards_in_deck
    cards_select 'd'
  end

  def cards_on_table
    cards_select 't'
  end

  def opponents_for(player)
    players.reject { |opponent| opponent == player }
  end

  def hand_of(player)
    hand = hands.where(player_id: player.id).first
  end

  def cards_for(player)
    hand = hands.where(player_id: player.id).first
    cards_in_hand(hand)
  end

  def cards_in_hand(hand)
    cards_select hand.number
  end

  def cards_put_one_to(key)
    deck_state[cards_in_deck.shuffle.first] = key.to_s
    save!
  end

  def cards_put_on_table(amount)
    amount.times { cards_put_one_to 't' }
  end

  def preflop
    hands.each do |hand|
      2.times { cards_put_one_to hand.number }
    end
    update_attribute :bet, 20
  end

  def on_change
    Game.connection.execute "LISTEN game"
    loop do
      Game.connection.raw_connection.wait_for_notify do |event, pid, payload|
        yield payload
      end
    end
  ensure
    Game.connection.execute "UNLISTEN game"
  end

  def finish!
    update_attribute :live, false
  end
end
