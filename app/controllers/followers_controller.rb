class FollowersController < ApplicationController
  before_action :set_follower, only: [:show, :edit, :update, :destroy]

  # GET /followers
  # GET /followers.json
  def index
    @model = Follower.new("1001", "1000")
    render plain: @model.myFollowing.inspect
  end

  def following
    @model = Follower.new("1015", "1000")
    render plain: @model.myFollower.inspect
  end

  # GET /followers/1
  # GET /followers/1.json
  def show
  end

  # GET /followers/new
  def new
    if params['id'] #id of the person you want to follow
      @model = Follower.new("1015", params['id'])
      if @model.Follow
        render plain: "success".inspect
      end
    end
    #render plain: "failed".inspect
  end

  def unfollow
    if params['id'] #id of the person you want to follow
      @model = Follower.new("1015", params['id'])
      if @model.unfollow
        render plain: "success".inspect
      end
    end
    #render plain: "failed".inspect
  end
  # GET /followers/1/edit
  def edit
  end

  # POST /followers
  # POST /followers.json
  def create
    @follower = Follower.new(follower_params)

    respond_to do |format|
      if @follower.save
        format.html { redirect_to @follower, notice: 'Follower was successfully created.' }
        format.json { render :show, status: :created, location: @follower }
      else
        format.html { render :new }
        format.json { render json: @follower.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /followers/1
  # PATCH/PUT /followers/1.json
  def update
    respond_to do |format|
      if @follower.update(follower_params)
        format.html { redirect_to @follower, notice: 'Follower was successfully updated.' }
        format.json { render :show, status: :ok, location: @follower }
      else
        format.html { render :edit }
        format.json { render json: @follower.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /followers/1
  # DELETE /followers/1.json
  def destroy
    @follower.destroy
    respond_to do |format|
      format.html { redirect_to followers_url, notice: 'Follower was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_follower
      @follower = Follower.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def follower_params
      params.fetch(:follower, {})
    end
end
