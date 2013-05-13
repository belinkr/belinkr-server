source 'http://ruby.taobao.org' 

group :production do
  gem 'i18n' 
  gem 'tzinfo' 
  gem 'json' 
  gem 'uuidtools'
  gem 'bcrypt-ruby'
  gem 'rack' 
  gem 'sinatra', require: 'sinatra/base' 
  gem 'virtus', '0.5.4'
  gem 'aequitas' 
  gem 'statemachine'
  gem 'redis' 
  gem 'redis-rack'
  gem 'carrierwave'
  gem 'mini_magick'
  gem 'pony'
  gem 'sanitize'
  #gem 'warbler', git: 'https://github.com/vanyak/warbler.git'
  gem 'tire'
  gem 'thin'
end
if ENV['RACK_ENV'] == 'staging'
  gem 'tinto', path: '../../../tinto/current'
else
  gem 'tinto', path: '../tinto'
  gem 'warbler', platform: :jruby, git:'https://github.com/jruby/warbler.git', ref:'ce3ce4df137504822e4cbb9399dee7e7dd767c44'
end

group :test do
  gem 'rack-test',  require: 'rack/test' 
  gem 'minitest',   require: 'minitest/spec' 
  gem 'guard'
  gem 'guard-minitest'
  gem 'libnotify'
  gem 'rb-inotify', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-fchange', require: false
  gem 'pry'
  gem 'pry-doc'
  gem 'minitest-documenter'
  gem 'rb-readline'

  # not available in ruby2.0
  #gem 'pry-debugger'
  #gem 'pry-rescue'
  #gem 'pry-stack_explorer'
end
