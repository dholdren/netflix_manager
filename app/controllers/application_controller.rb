class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  
  def netflix_auth
    if !current_user.access_token
      redirect_to '/netflix_auth/link_account'
    end
  end
  
end
