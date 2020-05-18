require 'json'
require 'sinatra'

Dir["./app/services/**/*.rb"].each {|f| require f}
Dir["./app/errors/**/*.rb"].each {|f| require f}

class App < Sinatra::Base

    post '/webhook' do
        request.body.rewind
        result = JSON.parse(request.body.read)["queryResult"]
        begin
            if result.has_value?("contexts")
                response = InterpretService.call(result["action"], result["context"][0]["parameters"])
            else
                response = InterpretService.call(result["action"], result["parameters"])
            end
        rescue ApiError::ApiCustomError => e
            response = e.message
        end

        content_type :json, charset: 'utf-8'
        {
            "fulfillmentText": response,
            "payload":{
                "telegram": {
                    "text": response,
                    "parse_mode": "Markdown"
                }
            }
        }.to_json

    end

end