class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  
  def netflix_auth
    if !current_user.access_token
      redirect_to '/netflix_auth/link_account'
    end
  end
  
  def netflix_client_for_user
    raise 'no current_user found' unless current_user
    @netflix_client_for_user ||= Netflix::Client.new(current_user.access_token, current_user.access_secret)
  end
  
  def netflix_client
    @netflix_client ||= Netflix::Client.new
  end
  
end
