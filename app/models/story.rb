class Story
  include Mongoid::Document
  include Mongoid::ActiveRecordBridge
  include Mongoid::Timestamps

  belongs_to_record :user
  belongs_to_record :track

  field :action, type: String
  field :seen_by, type: Array

  # Stories visible for, but not from the given user
  scope :visible_for, ->(user) {
    where(:track_id.in => Track.visible_for_user(user).map{|t| t.id})
    .not_in(:user_id => user.id)
    .desc(:created_at)
  }

  # Stories from the given user
  scope :from, ->(user) {
    where(:user_id => user.id)
    .desc(:created_at)
  }

  # Stories unseen by the given user
  scope :unseen_by, ->(user) {
    not_in(:seen_by => user.id)
    .desc(:created_at)
  }

  def subject
    user.as_json(:noinclude => true, :only => :username, :methods => :email_hash)
  end

  def as_json(options={})
    super :methods => [:subject, :track]
  end
end
