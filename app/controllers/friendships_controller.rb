class FriendshipsController < ApplicationController
  before_filter :authenticate_user!

  # POST /friendship
  def request_friendship
    @friendship = Friendship.new(params[:friendship])
    @user = current_user
    @friendship.initiator = @user

    respond_to do |format|
      if @friendship.save
        consumer = @friendship.consumer
        channel_for(consumer).trigger 'request', consumer.as_json
        format.html { redirect_to :action => :index, notice: 'Friendship was successfully requested.' }
        format.json { render json: @friendship, status: :created, location: @user }
      else
        format.html { render action: "show" }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /friendship/:id/confirm
  def confirm_friendship
    @friendship = current_user.friendships_as_consumer.find params[:id]
    @friendship.confirmed = true

    respond_to do |format|
      if @friendship.save
        initiator = @friendship.initiator
        channel_for(initiator).trigger 'confirm', initiator.as_json
        format.html { redirect_to :action => :index, notice: 'Friendship was successfully confirmed.' }
        format.json { render json: @friendship, status: :created, location: @user }
      else
        format.html { render action: "show" }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friendship/:id
  def destroy_friendship
    @friendship = current_user.friendships.find(params[:id]).first
    other_user = @friendship.initiator == current_user ? @friendship.consumer : @friendship.initiator
    confirmed = @friendship.confirmed
    @friendship.destroy
    if confirmed
      channel_for(other_user).trigger 'destroy', other_user.as_json
    else
      channel_for(other_user).trigger 'reject', other_user.as_json
    end

    respond_to do |format|
      format.html { redirect_to :action => :index, notice: 'Friendship was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private

  def channel_for(user)
    WebsocketRails[(user.token + "_friends").to_sym]
  end
end
