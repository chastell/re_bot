require 'sinatra'
require 'json'
require 'byebug'
require_relative 'services/facebook_connection'
require_relative 'services/net_connection'
require_relative 'models/facebook_post'
require_relative 'models/megadex_menu'

before '/fb/*' do
  @graph = FacebookConnection.new
end

before do
  response.headers['Access-Control-Allow-Origin'] = '*'
  content_type :json, charset: 'utf-8'
end

get '/fb/u_dziewczyn' do
  collect_feed { @feed = @graph.get_feed(FacebookPost::LunchSettings::CONNECTION_DATA) }
  lunch_settings = FacebookPost::LunchSettings.new
  post = FacebookPost.new(lunch_settings, @feed)
  halt "Nie ma jeszcze lunchu na dziś. Zwykle pojawia się koło godziny 11:00-11:15." if post.is_not_updated?
  post.as_json
end

get '/fb/wod' do
  collect_feed { @feed = @graph.get_feed(FacebookPost::WodSettings::CONNECTION_DATA) }
  wod_settings = FacebookPost::WodSettings.new
  FacebookPost.new(wod_settings, @feed).as_json
end

get '/megadex' do
  begin
    megadex_response = NetConnection.get_data(MegadexMenu::MEGADEX_URL)
  rescue => e
    halt 418, e.message || "I'm a teapot"
  end
  day = (!params[:text] || params[:text].empty?) ? Time.now.wday : params[:text].to_i
  MegadexMenu.new(megadex_response).for_day(day)
end

def collect_feed
  begin
    yield
  rescue Koala::Facebook::AuthenticationError
    halt 401, "Token do FB wygasł. Czas zaktualizować!"
  end
end


