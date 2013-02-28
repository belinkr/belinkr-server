source 'http://ruby.taobao.org' 

group :test do 
end
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
  gem 'tinto'
  gem 'warbler', git: 'https://github.com/vanyak/warbler.git'
  gem 'tire'
  gem 'thin'

  platforms :jruby do
  end
  platforms :ruby do
  end
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

  platforms :jruby do
  end
  platforms :ruby do
    gem 'pry-debugger'
    gem 'pry-rescue'
    #gem 'pry-stack_explorer'
  end
end
