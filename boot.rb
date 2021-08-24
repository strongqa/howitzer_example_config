require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

Dir[
  './emails/**/*.rb',
  './web/sections/**/*.rb',
  './web/pages/**/*.rb',
  './config/spyke.rb',
  './prerequisites/models/**/*.rb',
  './prerequisites/factory_bot.rb'
].each { |f| require f }

String.include Howitzer::Utils::StringExtensions
