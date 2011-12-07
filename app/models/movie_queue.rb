class MovieQueue# < ActiveRecord::Base
#  extend NetflixOauth

  attr_reader :user
  attr_reader :id
  attr_reader :etag
  attr_reader :name #name of account or subaccount
  attr_reader :user_id #userid of account or subaccount
  attr_reader :type #instant,disc
  attr_reader :subtype #available, saved
  attr_reader :discs #list of discs in the queue
  
  def self.get_disc_queue(user, netflix_user_id)
    netflix_user_id ||= user.netflix_user_id
    access_token = NetflixOauth.access_token(user)
    Rails.logger.debug "[#{self.name}.get_disc_queue] access_token: #{access_token.inspect}"
    netflix_user_response = access_token.get "/users/#{netflix_user_id}?output=json"
    #netflix_user_response = access_token.get "/users/#{netflix_user_id}?output=json&v=1.5"
    #netflix_user_response = access_token.get "/users/#{netflix_user_id}?output=json&v=2.0"
    
    netflix_user_json = netflix_user_response.body
    Rails.logger.debug "[#{self.name}.get_disc_queue] user_json: #{netflix_user_json}"

    netflix_user = JSON.parse(netflix_user_json)["user"]
    Rails.logger.debug "[#{self.name}.get_disc_queue] user: #{netflix_user}"
    name = "#{netflix_user["first_name"]} #{netflix_user["last_name"]}"
    
    disc_queue_response = access_token.get "/users/#{netflix_user_id}/queues/disc?max_results=500&output=json"
    disc_queue_json = disc_queue_response.body
    disc_queue = JSON.parse(disc_queue_json)["queue"]
    #puts "DISC QUEUE"
    #puts "****************************************************************************************"
    #puts disc_queue
    #puts "****************************************************************************************"
    
    MovieQueue.new(user, netflix_user_id, name, disc_queue, "disc")
  end
  
  def self.get_disc_queue_by_id(user, queue_id)
    queue_id =~ /users\/([^\/]*)\/.*/
    netflix_user_id = $1
    get_disc_queue(user, netflix_user_id)
  end
  
  def initialize(user, netflix_user_id, name, disc_queue_hash, type="disc")
    @user = user
    @id = "/users/#{netflix_user_id}/queues/#{type}"
    @user_id = netflix_user_id
    @name = name
    @type = type
    @etag = disc_queue_hash["etag"]
    @discs = Disc.convert_list(disc_queue_hash["queue_item"])
  end
  
  
  def add(title_ref, position, etag)
    access_token = NetflixOauth.access_token(user)
    queue_url = id #extract_queue_url(queue)
    Rails.logger.debug "[#{self.class.name}#add] queue_url #{queue_url}"
    #POST to /users/<userid>/queues/disc
    post_url = "#{queue_url}?output=json"
    response = access_token.post(post_url, {:etag => etag, :title_ref => title_ref, :position=> position})
    Rails.logger.debug "[#{self.class.name}#add] response #{response.inspect}"
    Rails.logger.debug "[#{self.class.name}#add] response body: #{response.body}"
    queue_json = response.body
    queue = JSON.parse(queue_json)
  end
  
  def remove(item_id, etag)
    Rails.logger.debug "[#{self.class.name}#remove] item_id #{item_id}, etag= #{etag}"
    access_token = NetflixOauth.access_token(user)
    #DELETE to /users/<userid>/queues/disc/available/<entry> (/<title_ref>)?
    delete_url = "#{item_id}?output=json"
    response = access_token.delete(delete_url) #, {:etag => etag})
    Rails.logger.debug "[#{self.class.name}#remove] response #{response.inspect}"
    Rails.logger.debug "[#{self.class.name}#remove] response body: #{response.body}"
    queue_json = response.body
    queue = JSON.parse(queue_json)
  end
  
end
