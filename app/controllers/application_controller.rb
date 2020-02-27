class ApplicationController < ActionController::Base
    helper_method :logged_in?
    helper_method :current_user
    
    
    def logged_in?
        if session[:userName] == nil
            redirect_to new_user_path
        end
    end
    def current_user
        return session[:userName]
    end
end
