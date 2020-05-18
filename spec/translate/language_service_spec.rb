require './spec/spec_helper.rb'

describe TranslateModule::LanguageAvailable do

    describe "#call" do
    
        context "success to get supported languages" do

            let(:lang_1){ FFaker::Lorem.characters(character_count = 2)}
            let(:lang_2){ FFaker::Lorem.characters(character_count = 2)}
            let(:lang_3){ FFaker::Lorem.characters(character_count = 2)}
            let!(:available_languages){ "pt = #{translated_lang_1},en = #{translated_lang_2},ja = #{translated_lang_3}" }
            let(:api_return_langs)do
                {
                    dirs:[],
                    langs:{
                        pt: lang_1,
                        en: lang_2,
                        ja: lang_3
                    }
                }
            end

            let(:translated_lang_1){ FFaker::Lorem.characters(character_count = 2)}
            let(:translated_lang_2){ FFaker::Lorem.characters(character_count = 2)}
            let(:translated_lang_3){ FFaker::Lorem.characters(character_count = 2)}

            before do
                allow(RestClient).to receive(:post) { OpenStruct.new(api_return_langs).to_h }
                allow(TranslateModule::TranslateService).to receive(:new){
                    -> {available_languages}
                }
                @response = TranslateModule::LanguageAvailable.new().call()
            end

            it "check if message contains languages and symbols" do
                available_languages.split(',').each do | lang |
                    expect(@response).to include(lang)
                end
            end

        end

        context "error to get supported languages" do

            context "Internal error" do
            
                let(:api_return)do
                    {
                        code: rand(401..402),
                        message: 'Error'
                    }
                end

                before do
                    allow(RestClient).to receive(:post) { OpenStruct.new(api_return).to_h }
                end

                it "raise a ApiComunicationError" do
                    error_message = 'Error when try comunicate with API.'
                    expect{ 
                        TranslateModule::LanguageAvailable.new().call()
                    }.to raise_error(ApiError::ApiComunicationError, error_message)
                end
            end

        end

    end

end