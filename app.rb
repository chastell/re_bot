require 'sinatra'
require 'json'
require 'byebug'
require_relative 'services/facebook_connector'
require_relative 'services/net_connector'
require_relative 'models/facebook_post'
require_relative 'models/lunch_post'
require_relative 'models/wod_post'
require_relative 'models/megadex_menu'

before '/fb/*' do
  @graph = FacebookConnector.connect!
end

before do
  response.headers['Access-Control-Allow-Origin'] = '*'
  content_type :json, charset: 'utf-8'
end

get '/fb/u_dziewczyn' do
  collect_feed { LunchPost.get_posts(@graph) }
  lunch_post = LunchPost.new(@feed)
  halt "Nie ma jeszcze lunchu na dziś. Zwykle pojawia się koło godziny 11:00-11:15." if lunch_post.is_not_updated?
  lunch_post.as_json
end

get '/fb/wod' do
  collect_feed { WodPost.get_posts(@graph) }
  WodPost.new(@feed).as_json
end

get '/megadex' do
  begin
    megadex_response = NetConnector.get_data(MegadexMenu::MEGADEX_URL)
  rescue => e
    halt 418, e.message || "I'm a teapot"
  end
  day = (!params[:text] || params[:text].empty?) ? Time.now.wday : params[:text].to_i
  MegadexMenu.new(megadex_response).for_day(day)
end

def collect_feed
  begin
    @feed = yield
  rescue Koala::Facebook::AuthenticationError
    halt 401, "Token do FB wygasł. Czas zaktualizować!"
  end
end
