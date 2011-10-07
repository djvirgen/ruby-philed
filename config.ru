require File.dirname(__FILE__) + '/vendor/rack/lib/rack'
require File.dirname(__FILE__) + '/vendor/sinatra/lib/sinatra'

set :run, false
set :environment, :production
set :views, "views"

require File.dirname(__FILE__) + '/app.rb'
run Sinatra::Application