class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  def main_profile_queue
    MovieQueue.get(self, self.netflix_user_id)
  end
  
  def sub_profile_queue
    MovieQueue.get(self, self.netflix_sub_user_id)
  end
end
