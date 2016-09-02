require 'sinatra'
require 'json'
require 'byebug'
require_relative 'services/facebook_connector'
require_relative 'services/net_connector'
require_relative 'models/facebook_post'
require_relative 'models/lunch_post'
require_relative 'models/wod_post'
require_relative 'models/megadex_menu'


before do
  response.headers['Access-Control-Allow-Origin'] = '*'
  content_type :json, charset: 'utf-8'
end

get '/u_dziewczyn' do
  lunch_post = LunchPost.new
  halt "Nie ma jeszcze lunchu na dziś. Zwykle pojawia się koło godziny 11:00-11:15." if lunch_post.is_not_updated?
  lunch_post.as_json
end

get '/wod' do
  WodPost.new.as_json
end

get '/megadex' do
  day = (!params[:text] || params[:text].empty?) ? Time.now.wday : params[:text].to_i
  MegadexMenu.new.for_day(day)
end
