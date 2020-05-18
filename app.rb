require 'json'
require 'sinatra'

Dir["./app/models/*.rb"].each {|f| require f}
Dir["./app/services/**/*.rb"].each {|f| require f}

class App < Sinatra::Base

    post '/webhook' do
        request.body.rewind
        result = JSON.parse(request.body.read)["queryResult"]
        p result
        if result["contexts"].present?
            response = InterpretService.call(result["action"], result["context"][0]["parameters"])
        else
            response = InterpretService.call(result["action"], result["parameters"])
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