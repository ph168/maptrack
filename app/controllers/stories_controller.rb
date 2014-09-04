class StoriesController < ApplicationController

  before_filter :authenticate_user!

  # GET /stories
  def index
    stories = Story.visible_for(current_user).each.to_a
    respond_to do |format|
      format.json { render json: stories }
    end
  end

  # GET /stories/unseen/count
  def unseen_count
    count = all_unseen.count
    respond_to do |format|
      format.json { render json: count }
    end
  end

  # GET /stories/1
  def show
    story = find_with params
    respond_to do |format|
      format.json { render json: story }
    end
  end

  # PUT /stories/1/seen
  def seen
    story = find_with params
    story.seen_by.push current_user.id
    story.save
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  # PUT /stories/seen
  def seen_all
    stories = all_unseen
    stories.add_to_set(seen_by: current_user.id)
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  def find_with(params)
    Story.visible_for(current_user).find params[:id]
  end

  def all_unseen
    Story.visible_for(current_user).unseen_by(current_user)
  end
end
