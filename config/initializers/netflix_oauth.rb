require 'netflix_oauth'

NetflixOauth.developer_key = ENV['NETFLIX_OAUTH_DEVELOPER_KEY']
NetflixOauth.developer_secret = ENV['NETFLIX_OAUTH_DEVELOPER_SECRET']
NetflixOauth.app_name = ENV['NETFLIX_OAUTH_APP_NAME'] || 'Profile Manager'
