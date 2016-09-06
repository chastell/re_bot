require 'koala'
require 'dotenv'
Dotenv.load

class FacebookConnection
  attr_reader :graph
  def initialize
    access_token = ENV["ACCESS_TOKEN"]
    @graph = Koala::Facebook::API.new(access_token)
  end

  def get_feed(connection_data)
    graph.get_connection(*connection_data)
  end
end
