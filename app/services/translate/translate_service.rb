require 'rest-client'
require './app/errors/api_error.rb'
require './app/models/api_code.rb'

module TranslateModule

    class TranslateService

        def initialize(params)
            p params
            @text = params[:text]
            text_language = params[:text_language]
            language_to_translate = params[:language_to_translate]
            @url = "#{ENV['API_URL']}translate?key=#{ENV['API_KEY']}&text=#{@text}&lang=#{text_language}-#{language_to_translate}"
            @only_translate = params[:only_translate]
        end

        def call
            raise ApiError::ApiTextMaxSizeError.new("A text #{@text} exceed a 10.000 characters.") if @text.length > 10000
            response = JSON.parse(RestClient.post @url, {}, {'Accept' => '*/*', 'Content-Type' => 'application/x-www-form-urlencoded'})
            status_code = response['code']
            case status_code
            when ApiCode::TRANSLATED
                if @only_translate
                    return response['text'][0]
                end
                "A tradução de #{@text} é #{response['text'][0]}"
            when ApiCode::INVALID_API_KEY, ApiCode::BLOCKED_API_KEY, ApiCode::EXCEEDED_DAILY_LIMIT
                raise ApiError::ApiComunicationError.new('Error when try comunicate with API.')
            when ApiCode::TRANSLATE_OPTION_NOT_SUPPORTED
                raise ApiError::ApiLanguageNotSupportedError.new('The sended language is not supported.')
            else
                raise ApiError::ApiCustomError.new("Unknow Error")
            end
        end

    end

end