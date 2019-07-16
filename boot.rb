require 'rubygems'
require 'bundler/setup'

Bundler.require(:default, :webkit)

Dir[
  './emails/**/*.rb',
  './web/sections/**/*.rb',
  './web/pages/**/*.rb',
  './config/spyke.rb',
  './prerequisites/models/**/*.rb',
  './prerequisites/factory_bot.rb'
].each { |f| require f }

String.send(:include, Howitzer::Utils::StringExtensions)
