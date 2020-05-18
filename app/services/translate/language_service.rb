require 'rest-client'
require './app/models/api_code.rb'

module TranslateModule

    class LanguageAvailable

        def initialize
            @url = "#{ENV['API_URL']}getLangs?key=#{ENV['API_KEY']}&ui=en"
        end

        def call
            response = JSON.parse(RestClient.post @url, {}, {'Accept' => '*/*', 'Content-Type' => 'application/x-www-form-urlencoded'})
            raise ApiError::ApiComunicationError.new('Error when try comunicate with API.') if response.has_value?(:code)
            langs = response['langs'].map {| value, key | "#{value} = #{key}"}.join(',')
            languages = translate_names(langs)
            message = "Esses são os idiomas que eu conheço: \n\n"
            message += "sigla | idioma\n"
            languages.each do | t |
               message += " - #{t}\n" 
            end
            message
        end

        private

        def translate_names(langs)
            translated_langs = TranslateModule::TranslateService.new({
                'text' => langs, 
                'text_language' => 'en', 
                'language_to_translate' => 'pt',
                'only_translate' => true
                }).call()
            translated_langs.split(',')
        end

    end

end