require 'oauth/consumer'
require 'oauth/token'

class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :netflix_auth
  
  def index
    if current_user.netflix_user_id && current_user.netflix_sub_user_id
      @queues = []
      #TODO @user.main_profile_queue, and @user.sub_profile_queue
      @queues << MovieQueue.get_disc_queue(current_user, current_user.netflix_user_id)
      @queues << MovieQueue.get_disc_queue(current_user, current_user.netflix_sub_user_id)
    else
      redirect_to :profiles_setup
    end
  end
  
end
