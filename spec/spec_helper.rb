require 'rack/test'
require 'rspec'
require 'fakeweb'
require 'timecop'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |config|
  config.include RSpecMixin

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

def fake_request(url, file_name)
  FakeWeb.clean_registry
  posts = File.read("#{File.dirname(__FILE__)}/feed_examples/#{file_name}")
  FakeWeb.register_uri(:get, url, body: posts)
end

def url_for(profile)
  if profile == "u_dziewczyn"
    "https://graph.facebook.com/udziewczynrestauracja/posts?access_token=#{ENV["ACCESS_TOKEN"]}&fields=message%2Cfull_picture%2Ccreated_time"
  elsif profile == "wod"
    "https://graph.facebook.com/CrossFitELEKTROMOC/posts?access_token=#{ENV["ACCESS_TOKEN"]}&fields=message%2Cpicture%2Ccreated_time"
  elsif profile == "megadex"
    "http://www.galeriasmaku.com.pl/zoliborz/admin/get.php"
  end
end
