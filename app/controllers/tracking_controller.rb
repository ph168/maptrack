# Controller used for simple tracking with GET requests

class TrackingController < ApplicationController
  before_filter :authenticate_with_token
  before_filter :find_track

  def track
    coordinate = @track.coordinates.build params
    coordinate.time = Time.at(params[:millis].to_i / 1000) if params[:millis]
    coordinate.user_id = @user.id
    if coordinate.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def authenticate_with_token
    @user = User.find_by_token params[:token]
    head :unauthorized unless @user
  end

  def find_track
    @track = Track.find_by_name params[:track]
    unless @track
      @track = Track.new :name => params[:track]
      @track.user = @user
      head :unprocessable_entity unless @track.save
    end
  end
end
