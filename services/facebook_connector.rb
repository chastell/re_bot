require 'koala'
require 'dotenv'
Dotenv.load

class FacebookConnector
  def self.connect!
    access_token = ENV["ACCESS_TOKEN"]
    Koala::Facebook::API.new(access_token)
  end
end
