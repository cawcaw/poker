class Game < ActiveRecord::Base

  STREETS = [
    :preflop,
    :flop,
    :turn,
    :river
  ]

  has_many :hands

  def cards
    deck_state.split
  end

  def cards_select(key)
    cards.each_index.select { |i| cards[i] == key }
  end

  def cards_in_deck
    cards_select 'd'
  end

  def cards_on_table
    cards_select 't'
  end

  def cards_for(user)
    hand = hands.where(user_id: user.id).first
    cards_in_hand(hand)
  end

  def cards_in_hand(hand)
    cards_select hand.number
  end

  def next_street
  end

  def finish!
    update_attribute :live, false
  end
end
