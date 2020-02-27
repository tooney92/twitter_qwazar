class ApplicationController < ActionController::Base
    helper_method :logged_in?

    

    def logged_in?
        if session[:userName] == nil
            redirect_to login_path
        end
    end
end
