class Game < ActiveRecord::Base

  before_create { deck_state = 'd'*52 }

  # STREETS = [ ...
  # this way better then use constant
  def streets
    [[:preflop, -> { preflop() }],
     [:flop,    -> { cards_put_on_table(3) }],
     [:turn,    -> { cards_put_on_table(1) }],
     [:river,   -> { cards_put_on_table(1) }]]
  end

  has_many :hands
  has_many :players, through: :hands

  def street
    read_attribute(:street) || 0
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
  end

  def add_ai_hand(stack)
    hands.create({ ai: true, game_id: id, number: hands.counts, stack: stack })
    next_street if all_in_place?
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
  end

  def finish!
    update_attribute :live, false
  end
end
