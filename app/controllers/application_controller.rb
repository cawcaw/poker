class ApplicationController < ActionController::Base
  before_action :authorize

  def authorize
    @player = Player.find_by_token request.cookies['token']
  end
end
