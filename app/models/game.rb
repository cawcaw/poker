class Game < ActiveRecord::Base

  STREETS = [
    :preflop,
    :flop,
    :turn,
    :river
  ]

  def cards_in_deck
  end

  def cards_on_table
  end

  def cards_in_hand(hand)
  end

  def next_street
  end

  def finish!
    update_attribute :live, false
  end
end
