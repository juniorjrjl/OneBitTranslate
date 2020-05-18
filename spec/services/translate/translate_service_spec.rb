require './spec/spec_helper.rb'
require './app/errors/api_error.rb'

describe TranslateModule::TranslateService do

    describe "#call" do

        let(:text) {FFaker::Lorem.word}
        let(:translated_text) {FFaker::Lorem.word}
        let(:text_language) { FFaker::Locale.language('random')}
        let(:language_to_translate) {FFaker::Locale.language('random')}

        context "success to translate" do
            
            let(:api_return)do
                {
                    code: 200,
                    lang: "#{text_language}-#{language_to_translate}",
                    text: [
                        translated_text
                    ]
                }
            end
        
            context "Send response" do
               
                before do
                    allow(RestClient).to receive(:post) {api_return.to_json}
                    @response = TranslateModule::TranslateService.new({
                                'text' => text, 
                                'text_language'=> text_language, 
                                'language_to_translate' => language_to_translate}).call()
                end

                it "will receive a translated text" do
                    expect(@response).to include(translated_text)
                end
                
                it "will receive a original text" do
                    expect(@response).to include(text)
                end
                
            end

            context "Only translated text" do

                before do
                    allow(RestClient).to receive(:post) {api_return.to_json}
                    @response = TranslateModule::TranslateService.new({
                                'text' => text, 
                                'text_language'=> text_language, 
                                'language_to_translate' => language_to_translate,
                                'only_translate' => true}).call()
                end

                it "will receive a translated text" do
                    expect(@response).to eq(translated_text)
                end

            end


        end

        context "error to translate" do
           
            context "Internal error" do
            
                let(:api_return)do
                    {
                        code: rand(401..402),
                        message: 'Error'
                    }
                end

                before do
                    allow(RestClient).to receive(:post) { api_return.to_json }
                end

                it "raise a ApiComunicationError" do
                    error_message = 'Error when try comunicate with API.'
                    expect{ 
                        TranslateModule::TranslateService.new({
                            'text' => text, 
                            'text_language' => text_language, 
                            'language_to_translate' => language_to_translate}).call()
                    }.to raise_error(ApiError::ApiComunicationError, error_message)
                end

            end

            context "exceeded text size" do
                
                let(:invalid_text) {FFaker::Lorem.characters(character_count = 10001)}
                let(:api_return)do
                    {
                        code: 413,
                        message: 'Max size exceeded error message'
                    }
                end

                before do
                    allow(RestClient).to receive(:post) {api_return.to_json}
                end

                it "raise a ApiTextMaxSizeError" do
                    error_message = "A text #{invalid_text} exceed a 10.000 characters."
                    expect{ 
                        TranslateModule::TranslateService.new({
                            'text' => invalid_text, 
                            'text_language' => text_language, 
                            'language_to_translate' => language_to_translate}).call() 
                    }.to raise_error(ApiError::ApiTextMaxSizeError, error_message)
                end

            end

            context "language not supported" do
                
                let(:api_return)do
                    {
                        code: 501,
                        message: 'Language not supported error message'
                    }
                end

                before do
                    allow(RestClient).to receive(:post) {api_return.to_json}
                end

                it "raise a ApiLanguageNotSupportedError" do
                    error_message = 'The sended language is not supported.'
                    expect{ 
                        TranslateModule::TranslateService.new({
                            'text' => text, 
                            'text_language' => text_language, 
                            'language_to_translate' => language_to_translate}).call()
                    }.to raise_error(ApiError::ApiLanguageNotSupportedError, error_message)
                end

            end
            
        end

    end

end