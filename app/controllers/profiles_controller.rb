require 'oauth/consumer'
require 'oauth/token'

class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :netflix_auth
  
  respond_to :json, :html
  
  def index
    @profiles = current_user.profiles
    respond_to do |format|
      format.html 
      format.json { render :json => @profiles.to_json(:only => [:id, :name], :methods => :disc_queue) }
    end
  end
  
end
