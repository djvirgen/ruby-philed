# Before filter
before do
  # Configuration
  @media_path = File.expand_path(File.dirname(__FILE__) + '/media')
  
  # No editing!
  request.path_info = request.path_info.gsub(/\/+$/, '') # remove trailing slash
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
    haml :directory, :locals => {:contents => contents(path), :path => path}
  else
    send_file @abs_path
  end
end

def contents(path)
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
        :rel => 'parent',
        :info => 'directory'
      }
    elsif (File.directory?("#{@abs_path}/#{x}")) then
      abs_path = "#{@abs_path}/#{x}"
      contents << {
        :url => "/" + "#{path}/#{x}".gsub(/^\/*/, ''),
        :abs_path => abs_path,
        :name => File.basename(abs_path),
        :rel => 'directory',
        :info => 'directory'
      }
    else
      abs_path = "#{@abs_path}/#{x}"
      contents << {
        :url => "/" + "#{path}/#{x}".gsub(/^\/*/, ''),
        :abs_path => abs_path,
        :name => File.basename(abs_path),
        :rel => 'file',
        :info => file_size(abs_path)
      }
    end
  end
  
  contents = contents.sort! do |x, y|
    if (x[:rel] == y[:rel]) then
      x[:name] <=> y[:name]
    elsif (x[:rel] == 'parent')
      -1
    else
      x[:rel] == 'directory' ? -1 : 1
    end
  end
  
  return contents
end

def file_size(path)
  size = File.size(path)
  
  if (size > 1_000_000) then
    "#{size / 1_000_000} MB"
  elsif (size > 1_000) then
    "#{size / 1_000} KB"
  else
    "#{size} B"
  end
end
