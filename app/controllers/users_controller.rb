class UsersController < ApplicationController
  before_action :logged_in?, :only => [:show, :edit, :destroy, :update]

  def new
  end
  
  def index
    @user = User.new()
    render plain: "opop"
  end
  
  def show
    # https://pbs.twimg.com/profile_images/469997005582790656/iGxrQ1FS_400x400.jpeg
    # https://pbs.twimg.com/media/ERes8ClVAAAT47S?format=jpg&name=medium
    @user = User.new()
    user = params[:id]
    @user_profile_url = ""
    @user_banner_url = ""

      if  $redis.get(user) == nil
        render plain: "sorry user does not exist!"

      elsif  @user.fetch_user(user)["profile_image_url"] == "nil" and @user.fetch_user(user)["profile_banner_url"] == "nil" 
        @user_profile_url = "https://pbs.twimg.com/profile_images/469997005582790656/iGxrQ1FS_400x400.jpeg"
        @user_banner_url = "https://pbs.twimg.com/media/ERes8ClVAAAT47S?format=jpg&name=medium"
        
        
      elsif  @user.fetch_user(user)["profile_banner_url"] != "nil" and @user.fetch_user(user)["profile_image_url"] != "nil"
        @user_profile_url = @user.fetch_user(user)["profile_image_url"]
        @user_banner_url = @user.fetch_user(user)["profile_banner_url"]
        
      elsif  @user.fetch_user(user)["profile_banner_url"] != "nil" and @user.fetch_user(user)["profile_image_url"] == "nil"
        @user_profile_url = "https://pbs.twimg.com/profile_images/469997005582790656/iGxrQ1FS_400x400.jpeg"
        @user_banner_url = @user.fetch_user(user)["profile_banner_url"]

      elsif  @user.fetch_user(user)["profile_banner_url"] == "nil" and @user.fetch_user(user)["profile_image_url"] != "nil"
        @user_profile_url = @user.fetch_user(user)["profile_image_url"]
        @user_banner_url = "https://pbs.twimg.com/media/ERes8ClVAAAT47S?format=jpg&name=medium"
        
      else
        @userName = @user.fetch_user(user)["username"]
        @user_id = @user.getkey(user)
      end
    end
    
    def edit
    end

    def update
      @user = User.new()
      
      if user_params[:image].blank?
        image_url = @user.fetch_user(session[:userName])["profile_image_url"]
      else
        blob = ActiveStorage::Blob.create_after_upload!(
          io: user_params[:image],
          filename: user_params[:image].original_filename,
          content_type: user_params[:image].content_type
        )
        image_url = url_for(blob)
      end
      if user_params[:banner].blank?
        banner_url = @user.fetch_user(session[:userName])["profile_banner_url"]
      else
        blob = ActiveStorage::Blob.create_after_upload!(
          io: user_params[:banner],
          filename: user_params[:banner].original_filename,
          content_type: user_params[:banner].content_type
        )
        banner_url = url_for(blob)
        # session[:url] = url_for(blob).inspect
      end
      @user.profile_update(session[:userName], user_params[:bio], user_params[:location], user_params[:date_of_birth], user_params[:website], image_url , banner_url)
      # render plain: @user.fetch_user(session[:userName])
      redirect_to user_path(session[:userName])    
      
    end
  

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

        status = @user.auth(user_params[:user_name], user_params[:password])
        if status.is_a?(String)
            flash[:error] = "invalid user name"
            redirect_to login_path
        elsif status == false
            flash[:error] = "invalid password"
            redirect_to login_path
        else
            userName = @user.fetch_user(user_params[:user_name])["username"]       
            session[:userName] = userName
            user_id = @user.getkey(session[:userName])
            redirect_to user_path(userName)
        end
    end

    def log_out
      session[:userName] = nil
      flash[:alert] = "logged out"
      redirect_to login_path
    end


    private
        def user_params
            params.require(:user).permit(:user_name, :email, :password, :bio, :location, :date_of_birth, :website, :image, :banner)
        end
    
end