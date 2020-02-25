class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    # GET /users
    # GET /users.json
    def new
        
    end
    def index
        @user = User.new()
    #   render plain: User.fetch()
      render plain: @user.fetch()
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
      @user.add(user_params[:user_name], user_params[:password], user_params[:email])
      if @user.save
        render plain: @user.user_id()
      end
    end

    private
        def user_params
            params.require(:user).permit(:user_name, :email, :password)
        end
    
end