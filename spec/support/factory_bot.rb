require 'factory_bot'

RSpec.configure do |c|

    c.include FactoryBot::Syntax::Methods
    c.before(:suite) do
        FactoryBot.find_definitions
    end

end