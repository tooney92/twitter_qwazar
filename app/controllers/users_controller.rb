class UsersController < ApplicationController
  before_action :logged_in?, :only => [:edit, :destroy, :update]

    def index
      @user = User.new()
      @post = Post.new()
      user_id = @user.getkey(@post.user(current_user_id))
      @userModel = @user.fetch_user(session[:userName])
        @post = Post.new(current_user_id)
        @posts = @post.all(user_id)
      # render plain:   
    end
    # GET /users/1
    # GET /users/1.json
    def show
       @user = User.new()
      # @userModel = User.fetch_user( 1 )
       @userModel = @user.fetch_user(session[:userName])
       @post = Post.new(current_user_id)
       user_id = @user.getkey(@post.user(current_user_id))
       @posts = @post.all(user_id)
       @model = Follower.new("", current_user_id)
       @followers =  @model.myFollower
       @model2 = Follower.new("0", current_user_id)
       @myFollowing = @model2.myFollowing
      #  render plain: @userModel.inspect
    end
    def follow
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
        # session[:url] = url_for(blob).inspect
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
      @user.profile_update(session[:userName], user_params[:bio], user_params[:location], user_params[:date_of_birth], user_params[:website], image_url,banner_url )
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
      elsif user_params[:email].include?" "
        flash[:error] = "invalid email! no spaces!"
        redirect_to new_user_path
      else
        @user.add(user_params[:user_name], user_params[:password], user_params[:email])
        # @userMail = {username:user_params[:user_name], email:user_params[:email]}
        # @user.save
        UserMailer.with(email: user_params[:email], username:user_params[:user_name]).welcome_email.deliver_now
        @user.save
        # render plain: user_params.inspect
        redirect_to new_user_path
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
            redirect_to new_user_path
        elsif status == false
            flash[:error] = "invalid password"
            redirect_to new_user_path
        else
            if $redis.sismember("username", user_params[:user_name])
              userName = @user.fetch_user(user_params[:user_name])["username"]       
              session[:userName] = userName
              user_id = @user.getkey(session[:userName])
              redirect_to user_path(userName)
              # render plain: userName
            else
              userName = $redis.get(user_params[:user_name])
              session[:userName] = userName
              user_id = @user.getkey(session[:userName])
              redirect_to user_path(userName)
              # render plain: username
          end
        end
    end

    def log_out
      session[:userName] = nil
      flash[:alert] = "logged out"
      redirect_to new_user_path
    end

    def forgot_password

    end

    def mail_password_reset
      @user = User.new()
     
      if $redis.sismember("email", user_params[:email])
        @username = $redis.get(user_params[:email])
        token = @user.set_token(user_params[:email])
        @generated_url = "/password_reset/#{token}"
        UserMailer.with(email: user_params[:email],username: @username , generated_url: @generated_url).reset_password.deliver_now
        # redirect_to "/password_reset/#{token}"
        flash[:success] = "Mail sent successfully"
        redirect_back fallback_location: root_path
        
      else
        flash[:error] = "email does not exist!"
        redirect_to forgot_password_path
      end

    end


    def password_reset
      @user = User.new()
      user_email = @user.token_get_email(params[:token])
      # render plain: "#{user_email}, #{@user.email_fetch_user(user_email)} "
    end

    def update_password
      @user = User.new()
      user = $redis.get(@user.token_get_email(params[:token]))
      former = @user.fetch_user(user)
      user_key = @user.getkey(user)
      # $redis.hgetall("user:#{user_key}", "password", user_params[:password])
      @user.hash_and_update_password(user_key, user_params[:password])
      new_details = @user.fetch_user(user)
      redirect_to new_user_path
      # render plain: "#{former}, \n \n \n #{new_details} \n\n\n #{user_params[:password]}"
    end


    def fetch_allusers
      # .map{ |num| num*2}
        @model = User.new()
        users_data = $redis.smembers("username").map{ |user| @model.fetch_user(user)}
        render plain: users_data
    end


    private
        def user_params
            params.require(:user).permit(:user_name, :email, :password, :bio, :location, :date_of_birth, :website, :image, :banner)
        end
    
end