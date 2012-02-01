require 'netflix_oauth'
require 'netflix'

Netflix::Client.consumer_key = ENV['NETFLIX_OAUTH_DEVELOPER_KEY']
Netflix::Client.consumer_secret = ENV['NETFLIX_OAUTH_DEVELOPER_SECRET']
