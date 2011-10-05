require 'sinatra'

# About
get '/about' do
  erb :about
end

# Folders and files
get '/*' do |path|
  path
end