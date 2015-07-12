class ApplicationController < ActionController::Base
  before_action :authorize

  def authorize
    @player = Player.find_by_token request.cookies['token']
    # unless @player || flash[:redirected]
    #   redirect_to :root
    #   flash[:redirected] = true
    # end
  end
end
