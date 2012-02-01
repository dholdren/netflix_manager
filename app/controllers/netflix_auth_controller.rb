require 'oauth/consumer'
require 'oauth/token'

class NetflixAuthController < ApplicationController
  before_filter :authenticate_user!
  
  def link_account_callback
    begin
      oauth_verifier = params[:oauth_verifier]
      request_token = session[:request_token]
      logger.debug "[#{self.class.name}#link_account_callback] request_token #{request_token.inspect}"
      access_token = netflix_client.handle_oauth_callback(request_token, oauth_verifier)
      logger.debug "[#{self.class.name}#link_account_callback] access_token #{access_token.inspect}"
      #normally, we want to set the netflix_user_id, 
      #but if we already have an access_token for this user, and the user_id is different,
      #we are adding a sub-profile
      if !current_user.access_token && current_user.profiles.count == 0
        current_user.profiles.build(:netflix_user_id => access_token.params["user_id"], :primary => true)
        current_user.access_token = access_token.token
        current_user.access_secret = access_token.secret
      else
        current_user.profiles.build(:netflix_user_id => access_token.params["user_id"], :primary => false)
      end
      current_user.save
    rescue
      logger.error "[#{self.class.name}#link_account_callback] #{$!.inspect}"
      flash[:alert] = "Error linking account"
    end
    redirect_to :profiles
  end
  
  def link_account 
    oauth_callback_url = netflix_auth_link_account_callback_url
    request_token, auth_url = netflix_client.oauth_via_callback(oauth_callback_url)
    session[:request_token] = request_token
    redirect_to auth_url
  end
  
end
