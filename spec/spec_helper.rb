$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
$:.unshift(File.dirname(__FILE__))

# TODO: Integration with Rails
# begin
#   require 'rails'
# rescue LoadError
# end

require 'bundler/setup'
Bundler.require


# TODO: Integration with Rails and Sinatra
# if defined? Rails
#   require 'fake_app/rails_app'

#   require 'rspec/rails'
# end
# if defined? Sinatra
#   require 'spec_helper_for_sinatra'
# end


require 'rspec'
require 'rspec/autorun'

RSpec.configure do |config|
  config.mock_with :rspec
end

require 'monsove'