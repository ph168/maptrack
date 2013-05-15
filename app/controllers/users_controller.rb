class UsersController < ApplicationController
  before_filter :authenticate_user!

  # GET /user
  def index
    @user = current_user
  end

  # GET /user/:name
  def show
    @user = User.find_by_name params[:name]
    @friendship = Friendship.new
  end

  # POST /user/friendship
  def request_friendship
    @friendship = Friendship.new(params[:friendship])
    @user = current_user
    @friendship.initiator = @user

    respond_to do |format|
      if @friendship.save
        format.html { redirect_to :action => :index, notice: 'Friendship was successfully requested.' }
        format.json { render json: @friendship, status: :created, location: @user }
      else
        format.html { render action: "show" }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user/friéndship/:id/confirm
  def confirm_friendship
    @friendship = current_user.friendships_as_consumer.find params[:id]
    @friendship.confirmed = true

    respond_to do |format|
      if @friendship.save
        format.html { redirect_to :action => :index, notice: 'Friendship was successfully confirmed.' }
        format.json { render json: @friendship, status: :created, location: @user }
      else
        format.html { render action: "show" }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end
end
