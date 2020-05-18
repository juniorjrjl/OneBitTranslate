require 'rspec'
require 'rack/test'
require 'ffaker'
require_relative '../app.rb'

Dir["./spec/support/**/*.rb"].each {|f| require f}
Dir["./app/services/**/*.rb"].each {|f| require f}

set :environment, :test

module RSpecMixin
    include Rack::Test::Methods

    def app
        App
    end

end

RSpec.configure do |c|
    c.include RSpecMixin
    ENV['log'] == true
end