class PostsController < ApplicationController
  # before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.new(current_user_id)
    # render plain: @posts.all.inspect
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  def post_tweet
    if $redis.EXISTS("next_post_id")
      @id = $redis.INCR("next_post_id")
    else
      @id = $redis.SET("next_post_id", 1)
      
    end
    @user = User.new()
    @custom_img = @user.fetch_user(session[:userName])["profile_image_url"]
    @text = "i love you"
    @model = Post.new(current_user_id, @id, post_params[:tweet])
    @time = "less than a minute ago"
    if @model.create
      ActionCable.server.broadcast 'tweet_channel',
      post: {post:post_params[:tweet], username:session[:userName], image: @custom_img, time:@time}
     redirect_to users_path
    else
      render plain: "failed".inspect
    end
  end
  # GET /posts/new
  def new
    if $redis.EXISTS("next_post_id")
      $redis.SET("next_post_id", 1)
      @id = $redis.INCR("next_post_id")
    else
      @id = $redis.INCR("next_post_id")
    end
    @text = "i love you"
    @model = Post.new(1000, @id, "i love you")
    if @model.create
      render plain: "success".inspect
    else
      render plain: "failed".inspect
    end
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
       
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:tweet).permit(:tweet)
    end
    
end
