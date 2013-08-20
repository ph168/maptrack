class UsersController < ApplicationController
  before_filter :authenticate_user!

  # GET /user
  def index
    @user = current_user
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  # GET /user/:name
  def show
    @user = User.find_by_name params[:name]
    @friendship = Friendship.new
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  # GET /user/edit
  def edit
    @user = current_user

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  # PUT /user
  def update
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { render :partial => 'users/userdata' }
      else
        format.html { render action: "edit" }
      end
    end
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

  # PUT /user/friendship/:id/confirm
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
