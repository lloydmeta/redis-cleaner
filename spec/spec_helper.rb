require 'bundler/setup'
require 'rspec'
require 'rspec/mocks'
require 'redis_cleaner'

Dir[File.expand_path('../support/**/*', __FILE__)].each { |f| require f }

RSpec.configure do |config|

  #nothing yet

end