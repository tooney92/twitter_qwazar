class ApplicationController < ActionController::Base
    
    def index
        render plain: "hello"
    end
end
