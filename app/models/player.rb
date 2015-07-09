class Player < ActiveRecord::Base

  before_create :set_token

  validates :name, presence: true, length: { minimum: 3 }

  private

  def set_token
    new_token = ""
    16.times { new_token << (rand(36).to_s(36)) }
    self.token = new_token
  end
end
