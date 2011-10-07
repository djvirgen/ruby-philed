require 'vendor/rack/lib/rack'
require 'vendor/haml/lib/haml'
require 'vendor/sinatra/lib/sinatra'
require 'rubygems'

set :run, false
set :environment, :production
set :views, "views"

log = File.new("log/sinatra.log", "w")
STDOUT.reopen(log)
STDERR.reopen(log)

require File.dirname(__FILE__) + '/app.rb'
run Sinatra::Application
