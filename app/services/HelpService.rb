class HelpService
    
    def self.call
        response = "Meus comandos \n\n"
        response += "help \n"
        response += "'Lista de comandos que conheço'\n\n"
        response += "Traduza um texto\n"
        response += "'traduzo um texto de idioma X para idioma Y'\n\n"
        response += "Liste idiomas\n"
        response += "'listo os idiomas que conheço'\n\n"
        response
    end

end