class User < ActiveRecord::Base
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_many :profiles
  
  def disc_queues
    @disc_queues ||= profiles.map(&:disc_queue)
  end
  
  private
  def netflix_user
    @disc_queues ||= netflix_client.user(self.netflix_user_id)
  end
  
  def netflix_client
    @netflix_client ||= Netflix::Client.new(self.access_token, self.access_secret)
  end
  
  def reload
    #kill and lazy load later
    @disc_queues = nil
    @netflix_user = nil
    super
  end
  
end
