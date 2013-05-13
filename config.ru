require './API'
puts ENV['RACK_ENV']
Belinkr::API.use Rack::Session::Redis
run Belinkr::API.new
