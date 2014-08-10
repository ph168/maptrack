class PlacesController < ApplicationController
  include TracksHelper

  before_filter do
    unless find_shared_track
      authenticate_user!
      find_track
    end
  end

  # GET /places
  def index
    places = places_for_track.each.to_a
    respond_to do |format|
      format.json { render json: places }
    end
  end

  # GET /places/1
  def show
    place = places_for_track.find params[:id]
    respond_to do |format|
      format.json { render json: place }
    end
  end

  # GET /places/new
  def new
    place= Place.new

    respond_to do |format|
      format.json { render json: place }
    end
  end

  # GET /places/1/edit
  def edit
    @place = places_for_track.find params[:id]
  end

  # POST /places
  def create
    place = places_for_track.build params[:place]

    respond_to do |format|
      if place.save
        format.json { render json: place, status: :created }
      else
        format.json { render json: place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /places/1
  def update
    place = places_for_track.find params[:id]

    respond_to do |format|
      if place.update_attributes params[:place]
        format.json { head :no_content }
      else
        format.json { render json: place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1
  def destroy
    place = places_for_track.find params[:id]
    place.destroy

	respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  def places_for_track
    Place.in(coordinate_id: @track.coordinates.map{ |c| c.id })
  end

  def find_track
    @track = Track.find params[:track_id]
  end
end
