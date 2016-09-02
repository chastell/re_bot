require 'koala'
require 'dotenv'
Dotenv.load

class FacebookConnector
  def self.get_posts(connection_data)
    access_token = ENV["ACCESS_TOKEN"]
    graph = Koala::Facebook::API.new(access_token)
    begin
      graph.get_connection(*connection_data)
    rescue Koala::Facebook::AuthenticationError
      halt 401, "Token do FB wygasł. Czas zaktualizować!"
    end
  end
end
