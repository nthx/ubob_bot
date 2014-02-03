source 'https://rubygems.org'

platforms :ruby do
end

platforms :jruby do
end

group :development, :production, :test do
  gem 'aquarium'      #for glue on domain-usecases-services
  gem 'xmpp4r'        #for jabber protocol
  gem 'hpricot'       #??


  gem 'resque-status' #for queueing async jobs with identifier
  #adds "redis/sinatra" dependencies
  gem 'resque-pool'   #for resque management

  gem 'mechanize'     #for downloading of links
end

group :test do
  gem 'rack-test'
  gem 'rspec',  '~> 2.4'
end

