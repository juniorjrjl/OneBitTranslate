require_relative './../spec_helper.rb'

describe InterpretService do

    describe "#call" do

        it "Translate" do
            allow(TranslateModule::LanguageAvailable).to receive(:new).and_raise("Wrong call")
            allow(HelpService).to receive(:call).and_raise("Wrong call")
            allow(TranslateModule::TranslateService).to receive(:new){
                -> {true}
            }
            expect{ InterpretService.call('translate', nil) }.not_to raise_error
        end

        it "Get languages" do
            allow(HelpService).to receive(:call).and_raise("Wrong call")
            allow(TranslateModule::TranslateService).to receive(:new).and_raise("Wrong call")
            allow(TranslateModule::LanguageAvailable).to receive(:new){
                -> {true}
            }
            expect{ InterpretService.call('get_languages', nil) }.not_to raise_error
        end

        it "help" do
            allow(HelpService).to receive(:call){
                -> {true}
            }
            allow(TranslateModule::TranslateService).to receive(:new).and_raise("Wrong call")
            allow(TranslateModule::LanguageAvailable).to receive(:new).and_raise("Wrong call")
            expect{ InterpretService.call('help', nil) }.not_to raise_error
        end

        it "Unknow command" do
            allow(HelpService).to receive(:call).and_raise("Wrong call")
            allow(TranslateModule::TranslateService).to receive(:new).and_raise("Wrong call")
            allow(TranslateModule::LanguageAvailable).to receive(:new).and_raise("Wrong call")
            expect{ InterpretService.call('1', nil) }.not_to raise_error
        end

    end

end