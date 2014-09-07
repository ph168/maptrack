class CommentsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_track

  # GET /comments
  def index
	comments = @comments
    respond_to do |format|
      format.json { render json: comments }
    end
  end

  # GET /comments/1
  def show
    story = find_visible_with params
    respond_to do |format|
      format.json { render json: story }
    end
  end

  # POST /comments
  def create
    comment = @comments.build params[:comment]
    comment.user = current_user
    respond_to do |format|
      if comment.save
        format.json { render json: comment, status: :created }
      else
        format.json { render json: comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  def update
    comment = find_own_with params
    respond_to do |format|
      if comment.update_attributes params[:comment]
        format.json { head :no_content }
      else
        format.json { render json: comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  def destroy
    comment = find_own_with params
    comment.destroy

	respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  def find_track
    track = Track.visible_for_user(current_user).find params[:track_id]
    @comments = track.comments
  end

  def find_visible_with(params)
    @comments.visible_for(current_user).find params[:comment_id]
  end

  def find_own_with(params)
    @comments.for_user(current_user).find params[:comment_id]
  end
end
