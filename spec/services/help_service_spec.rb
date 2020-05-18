require_relative './../spec_helper.rb'

describe HelpService do

    describe "#call" do

        it "Response have then main commands" do
            response = HelpService.call()
            expect(response).to match('help')
            expect(response).to match('Traduza um texto')
            expect(response).to match('Liste idiomas')
        end

    end

end