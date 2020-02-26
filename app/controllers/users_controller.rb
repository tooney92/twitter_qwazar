class UsersController < ApplicationController
    # require "scrypt"
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    # GET /users
    # GET /users.json
    def new
    end

    def index
        @user = User.new()
      render plain: "opop"
    end
    # GET /users/1
    # GET /users/1.json
    def show
    end
    # GET /users/new
    # GET /users/1/edit
    def edit
    end
    # POST /users
    # POST /users.json
    def create
      @user = User.new()
      if @user.exists(user_params[:user_name])
        flash[:error] = "username: #{user_params[:user_name]} already exists!"
        redirect_to new_user_path
      elsif user_params[:email] == "" and user_params[:password] == ""
        flash[:error] = "please provide email and password"
        redirect_to new_user_path
      elsif user_params[:email] == ""
        flash[:error] = "empty email field!!!!"
        redirect_to new_user_path
      elsif user_params[:password] == ""
        flash[:error] = "please provide password"
        redirect_to new_user_path
      elsif user_params[:user_name].include?" "
        flash[:error] = "invalid user name! no spaces!"
        redirect_to new_user_path
      else
        @user.add(user_params[:user_name], user_params[:password], user_params[:email])
        @user.save
        # render plain: user_params.inspect
        redirect_to login_path
      end
        # render plain: user_params.inspect
    end

    def login

    end

    def login_user
        @user = User.new()
        status = @user.auth(user_params[:user_name], user_params[:password])
        if status.is_a?(String)
            flash[:error] = "invalid user name"
            redirect_to login_path
        elsif status == false
            flash[:error] = "invalid password"
            redirect_to login_path
        else
            render plain: "legit"
        end
        
    end

    private
        def user_params
            params.require(:user).permit(:user_name, :email, :password)
        end
    
end