require 'sinatra'

# Before filter
before do
  # Configuration
  @media_path = File.expand_path(File.dirname(__FILE__) + '/media')
  
  # No editing!
  request.path_info = request.path_info.gsub(/\/+$/, '')
  @abs_path = "#{@media_path}#{request.path_info}"
end

# About
get '/about' do
  erb :about
end

# Folders and files
get '/*' do |path|
  unless File.exists?(@abs_path)
    return "#{@abs_path} does not exist!"
  end
  
  if (File.directory?(@abs_path)) then
    # Show directory contents
    contents = []
    Dir.foreach(@abs_path) do |x|
      # Skip current directory
      next if (x == '.')
    
      # Skip parent directory if at top
      next if (x == '..' && @abs_path == @media_path)
    
      if (x == '..') then
        contents << {
          :url => '/' + File.dirname(path).gsub(/^\.$/, ''),
          :abs_path => File.basename(@abs_path),
          :name => '.. Parent directory',
          :rel => 'parent'
        }
      else
        abs_path = "#{@abs_path}/#{x}"
        contents << {
          :url => "/" + "#{path}/#{x}".gsub(/^\/*/, ''),
          :abs_path => abs_path,
          :name => File.basename(abs_path),
          :rel => (File.directory?("#{@abs_path}/#{x}") ? 'directory' : 'file')
        }
      end
    end

    haml :directory, :locals => {:contents => contents}
  else
    send_file @abs_path
  end
end