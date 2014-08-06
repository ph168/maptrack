class PlacesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_track

  # GET /places
  def index
    places = Place.in(coordinate_id: @track.coordinates.map{ |c| c.id }).each.to_a
    respond_to do |format|
      format.json { render json: places }
    end
  end

  # GET /places/1
  def show
    place = Place.find params[:id]
    respond_to do |format|
      format.json { render json: place }
    end
  end

  def find_track
    @track = Track.find params[:track_id]
  end
end
