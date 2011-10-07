require File.dirname(__FILE__) + '/vendor/rack/lib/rack'
require File.dirname(__FILE__) + '/vendor/sinatra/lib/sinatra'

set :run, true
set :environment, :production
set :views, "views"

require 'app.rb'
run Sinatra::Application