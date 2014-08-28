class UsersController < ApplicationController
  before_filter :authenticate_user!

  # GET /user
  def index
    @user = current_user
    respond_to do |format|
      format.html { render :layout => false }
      format.json { render :json => current_user }
    end
  end

  # GET /user/search?q=query
  def search
    users = User.find_by_query params[:q]
    respond_to do |format|
      format.json { render :json => users.to_json(:only => [:id, :username], :methods => :email_hash) }
    end
  end

  # GET /user/:name
  def show
    @user = User.find_by_name params[:name]
    @friendship = Friendship.new
    respond_to do |format|
      format.js { render :layout => false }
      format.json { render :json => @user }
    end
  end

  # GET /user/edit
  def edit
    @user = current_user

    respond_to do |format|
      format.js { render :layout => false }
      format.json { render :json => user }
    end
  end

  # PUT /user
  def update
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { render :partial => 'users/userdata' }
	format.json { head :no_content }
      else
        format.html { render action: "edit" }
	format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
end
