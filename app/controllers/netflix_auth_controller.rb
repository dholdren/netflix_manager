require 'oauth/consumer'
require 'oauth/token'

class NetflixAuthController < ApplicationController
  before_filter :authenticate_user!
  
  #def show
  #  #should really show a form with a username and password
  #end
  #
  #def login
  #  #should really show a form (show) with a username and password, and this be a post, for now mock
  #  ##@user = User.find_or_create_by_name('Dean Holdren')
  #  ##session[:user_id] = @user.id
  #  #if @user.access_token
  #  if current_user.access_token
  #    redirect_to :profiles
  #  else
  #    link_account
  #  end
  #end
  
  def link_account_callback
    request_token = session[:netflix_request_token] 
    access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier]) 
    #doesnt workaccess_token = get_consumer().get_access_token(:token => params[:oauth_token], :oauth_verifier => params[:oauth_verifier])
    logger.debug "[#{self.class.name}#link_account_callback] access_token #{access_token.inspect}"
    #normally, we want to set the netflix_user_id, 
    #but if we already have an access_token for this user, and the user_id is different,
    #we are adding a sub-profile
    if current_user.access_token && current_user.netflix_user_id != access_token.params["user_id"]
      #raise "THEY ARE DIFFERENT, ADD"
      current_user.netflix_sub_user_id = access_token.params["user_id"]
    else
      current_user.netflix_user_id = access_token.params["user_id"]
      current_user.access_token = access_token.token
      current_user.access_secret = access_token.secret
    end
    current_user.save
    redirect_to :profiles
  end
  
  def link_account 
    #oauth_callback = 'http://127.0.0.1:3000/netflix_auth/link_account_callback'
    oauth_callback_url = netflix_auth_link_account_callback_url
    request_token = NetflixOauth.consumer().get_request_token(:oauth_callback => 
      oauth_callback_url, :application_name => NetflixOauth.app_name) 
    session[:netflix_request_token] = request_token 
    url = request_token.authorize_url(:oauth_consumer_key => 
      NetflixOauth.developer_key) 
    redirect_to url 
  end
  
end
