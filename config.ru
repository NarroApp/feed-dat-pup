require "rubygems"
require "bundler/setup"
require "sinatra"
require "haml"
require 'rack/cache'
require "./app"

run Sinatra::Application
