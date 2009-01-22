require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'timeout'


get '/' do
  begin
    if !params['url'] || !params['callback']
      "#{params['callback']}({'error' : 'Must include both 'url' and 'callback' parameters.'})"
    elsif params['url'].empty? || params['callback'].empty?
      "#{params['callback']}({'error' : 'Must include a value for both 'url' and 'callback' parameters.'})"
    else
      puts params['url']
      Timeout::timeout(15) do 
        "#{params['callback']}(#{open(params['url']).read})"
      end      
    end
  rescue Timeout::Error
    "#{params['callback']}({'error' : 'Requesting the json took too long. Time limit is 15 seconds.'})"
  rescue Errno::ENOENT => e
    "#{params['callback']}({'error' : 'Problem requesting the json: #{e}'})"
  rescue Exception => e
    "#{params['callback']}({'error' : 'A problem ocurred: #{e}'})"
  end
end