class TracksController < ApplicationController
  include TracksHelper

  before_filter do
    find_shared_track or authenticate_user!
  end

  # GET /tracks
  # GET /tracks.json
  def index
    @my_tracks = tracks_for_current_user
    @friends_tracks = tracks_for_friends_of_current_user

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @my_tracks + @friends_tracks, :include => :summary }
    end
  end

  # GET /tracks/1
  # GET /tracks/1.json
  def show
    unless @track
      @track = track_accessible_for_current_user params[:id]
      @track.summary.set_format MetricSystem.new
    end
    readonly = (@track.user != current_user)

    respond_to do |format|
      format.html { render :partial => 'tracks/show', :locals => { :track => @track, :readonly => readonly } }
      format.json { render json: @track }
      format.xml
    end
  end

  # GET /tracks/new
  # GET /tracks/new.json
  def new
    @track = Track.new

    respond_to do |format|
      format.json { render json: @track }
    end
  end

  # GET /tracks/1/edit
  def edit
    @track = track_owned_by_current_user params[:id]

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  # POST /tracks
  # POST /tracks.json
  def create
    @track = Track.new(params[:track])
    @track.user = current_user

    respond_to do |format|
      if @track.save
        format.html { redirect_to tracks_path, notice: 'Track was successfully created.' }
        format.json { render json: @track, status: :created, location: @track }
      else
        format.html { render action: "new" }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tracks/1
  # PUT /tracks/1.json
  def update
    @track = track_owned_by_current_user params[:id]

    respond_to do |format|
      if @track.update_attributes(params[:track])
        format.html { redirect_to @track, notice: 'Track was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracks/1
  # DELETE /tracks/1.json
  def destroy
    @track = track_owned_by_current_user params[:id]
    @track.destroy

    respond_to do |format|
      format.html { redirect_to tracks_url }
      format.json { head :no_content }
    end
  end

  # PUT /tracks/1/close
  def close
    track = track_owned_by_current_user params[:id]
    track.close!

    respond_to do |format|
      format.html { redirect_to @track, notice: 'Track was successfully closed.' }
      format.json { head :no_content }
    end
  end

  private

  def tracks_for_current_user
    Track.for_user current_user
  end

  def tracks_for_friends_of_current_user
    Track.find_all_by_user_id_and_public(current_user.friends.select{|u| u.id}, true)
  end

  # Returns the track with given id if it is owned by current_user
  def track_owned_by_current_user(id)
    tracks_for_current_user.find id
  end

  # Returns the track with given id if it is accessible for current_user
  def track_accessible_for_current_user(id)
    Track.find_by_id_and_user_id(id, current_user.friends.select{|u| u.id} + [current_user.id])
  end
end
