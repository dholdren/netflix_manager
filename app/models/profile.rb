class Profile < ActiveRecord::Base
  
  belongs_to :user
  
  default_scope :order => 'position'
  
  def disc_queue
    @disc_queue ||= netflix_user.available_disc_queue
  end
  
  #should override the database attribute
  def name
    "#{netflix_user.first_name} #{netflix_user.last_name}"
  end
  
  private
  def netflix_user
    @netflix_user ||= netflix_client.user(netflix_user_id)
  end
  
  def netflix_client
    @netflix_client ||= Netflix::Client.new(user.access_token, user.access_secret)
  end
  
  def reload
    #kill and lazy load later
    @disc_queue = nil
    @netflix_user = nil
    super
  end
  
end
