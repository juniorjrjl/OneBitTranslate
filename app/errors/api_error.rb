module ApiError

    class ApiCustomError < StandardError
        def initialize(message)
            super(message)
        end
    end

    class ApiComunicationError < ApiCustomError;end

    class ApiTextMaxSizeError < ApiCustomError;end

    class ApiLanguageNotSupportedError < ApiCustomError;end

end