require './API'

Belinkr::API.use Rack::Session::Redis
run Belinkr::API.new
