class CoordinatesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_track

  # GET /coordinates
  # GET /coordinates.json
  def index
    @coordinates = @track.coordinates.for_user current_user

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @coordinates }
    end
  end

  # GET /coordinates/1
  # GET /coordinates/1.json
  def show
    @coordinate = coordinate_for_current_user params[:id]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @coordinate }
    end
  end

  # GET /coordinates/new
  # GET /coordinates/new.json
  def new
    @coordinate = Coordinate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @coordinate }
    end
  end

  # GET /coordinates/1/edit
  def edit
    @coordinate = coordinate_for_current_user params[:id]
  end

  # POST /coordinates
  # POST /coordinates.json
  def create
    @coordinate = @track.coordinates.build(params[:coordinate])
    @coordinate.user_id = current_user.id

    respond_to do |format|
      if @coordinate.save
        format.html { redirect_to [@track, @coordinate], notice: 'Coordinate was successfully created.' }
        format.json { render json: @coordinate, status: :created }
      else
        format.html { render action: "new" }
        format.json { render json: @coordinate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /coordinates/1
  # PUT /coordinates/1.json
  def update
    @coordinate = coordinate_for_current_user params[:id]
    @coordinate.user_id = current_user.id

    respond_to do |format|
      if @coordinate.update_attributes(params[:coordinate])
        format.html { redirect_to [@track, @coordinate], notice: 'Coordinate was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @coordinate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coordinates/1
  # DELETE /coordinates/1.json
  def destroy
    @coordinate = coordinate_for_current_user params[:id]
    @coordinate.destroy

    respond_to do |format|
      format.html { redirect_to track_coordinates_url }
      format.json { head :no_content }
    end
  end

  private

  def coordinate_for_current_user id
    @track.coordinates.for_user(current_user).find id
  end

  def find_track
    @track = Track.find params[:track_id]
  end
end
