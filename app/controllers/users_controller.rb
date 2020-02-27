class UsersController < ApplicationController
    # require "scrypt"
    # before_action :set_user, only: [:show, :edit, :update, :destroy]
    # GET /users
    # GET /users.json
    def new
    end

    def index
        @user = User.new()
      # render plain: "opop"
    end
    # GET /users/1
    # GET /users/1.json
    def show
       user = User.new()
      # @userModel = User.fetch_user( 1 )
       @userModel = user.fetch_user(session[:userName])
      #  render plain: @userModel.inspect
    end
    def follow
    end
    
    # GET /users/new
    # GET /users/1/edit
    def edit
    end
    # POST /users
    # POST /users.json
    def create
      @user = User.new()
      if @user.exists(user_params[:user_name], user_params[:email]) == "username already exists"
        flash[:error] = "username: #{user_params[:user_name]} already exists!"
        redirect_to new_user_path
      elsif @user.exists(user_params[:user_name], user_params[:email]) == "email already exists"
        flash[:error] = "email: #{user_params[:email]} already exists!"
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
      elsif user_params[:password].length < 8
        flash[:error] = "minimum of 8 characters for password!"
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
        userName = @user.fetch_user(user_params[:user_name])["username"]
        status = @user.auth(user_params[:user_name], user_params[:password])
        if status.is_a?(String)
            flash[:error] = "invalid user name"
            redirect_to login_path
        elsif status == false
            flash[:error] = "invalid password"
            redirect_to login_path
        else
            # render plain: 
            session[:userName] = userName
            user_id = @user.getkey(session[:userName])            
            redirect_to user_path(user_id)
        end
        
    end

    private
        def user_params
            params.require(:user).permit(:user_name, :email, :password)
        end
    
end