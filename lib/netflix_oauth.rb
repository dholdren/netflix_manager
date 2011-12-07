require 'oauth/consumer'

module NetflixOauth
  class << self
    attr_accessor :developer_key
    attr_accessor :developer_secret
    
    def consumer
      OAuth::Consumer.new(
        NetflixOauth.developer_key,
        NetflixOauth.developer_secret,
        :site => "http://api.netflix.com", 
        :request_token_url => "http://api.netflix.com/oauth/request_token", 
        :access_token_url => "http://api.netflix.com/oauth/access_token", 
        :authorize_url => "https://api-user.netflix.com/oauth/login")
    end

    def access_token(user)
      access_token = OAuth::AccessToken.new(consumer(), user.access_token, user.access_secret)
    end
    
  end
  
end