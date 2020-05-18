class InterpretService

    def self.call action, params
        case action
        when 'get_languages'
            TranslateModule::LanguageAvailable.new().call()
        when 'translate'
            TranslateModule::TranslateService.new(params).call()
        when 'help'
            HelpService.call()
        else
            'Não entendi o que você quer'
        end    
    end

end