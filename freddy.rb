require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'timeout'

set :run, false
disable :reload

TIME_OUT = 15

get '/' do
  begin
    if !params['url'] || !params['callback']
      "#{params['callback']}({'error' : 'Must include both 'url' and 'callback' parameters.'})"
    elsif params['url'].empty? || params['callback'].empty?
      "#{params['callback']}({'error' : 'Must include a value for both 'url' and 'callback' parameters.'})"
    else
      Timeout::timeout(TIME_OUT) do 
        "#{params['callback']}(#{open(params['url']).read})"
      end      
    end
  rescue Timeout::Error
    "#{params['callback']}({'error' : 'Requesting the json took too long. Time limit is #{TIME_OUT} seconds.'})"
  rescue Errno::ENOENT => e
    "#{params['callback']}({'error' : 'Problem requesting the json: #{e}'})"
  end
end

get '/about' do
  "Freddy the JSON Slasher! <a href='http://github.com/stepchange/freddy/tree/master'>Read more</a>"
end