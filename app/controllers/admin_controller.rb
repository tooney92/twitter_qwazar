class AdminController < ApplicationController

    def index
        @user = User.new()
        @users = @user.fetch_allusers
        render :layout => 'index'
    end
    
    
    def deleteuser
        @model = User.new()
        id = params[:userid]
        user_name = @model.getname(id)
        
        # render plain: "na me #{params[:userid]}"
        # render plain: "#{@model.delete_user(params[:userid])}"
        flash[:success] = "#{user_name}, deleted sucessfully!"
        @model.delete_user(id)
        redirect_to admin_path
    end
    
    def make_admin
        model = User.new()
        model.make_admin(params[:userid])
        user_name = model.getname(params[:userid])
        redirect_to admin_path
        # render plain: "#{model.fetch_user(user_name)}"
    end
    def remove_admin
        model = User.new()
        model.remove_admin(params[:userid])
        user_name = model.getname(params[:userid])
        redirect_to admin_path
        # render plain: "#{model.fetch_user(user_name)}"
    end
    
    def edit_user
        @model = User.new()
        @username = @model.getname(params[:userid])
        @email = @model.fetch_user(@username)['email']
        @id = params[:userid]
        # render plain: @username
        render :layout => 'index'
    end
    
    def update_user
        @model = User.new()
        @username = @model.getname(params[:userid])
        user_id = params[:userid]
        new_username = user_params[:user_name]
        new_useremail = user_params[:email]
        @model.edit_user(user_id, new_useremail, new_username)
        # render :layout => 'index'
        flash[:success] = "updated sucessfully!"
        redirect_to admin_path
        
    end

    private

        def user_params
            params.require(:user).permit(:user_name, :email)
        end
    
end
