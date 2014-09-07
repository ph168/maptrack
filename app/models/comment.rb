class Comment
  include Mongoid::Document
  include Mongoid::ActiveRecordBridge
  include Mongoid::Timestamps

  belongs_to_record :user
  belongs_to_record :track
  belongs_to :place

  field :text, type: String

  scope :visible_for, ->(user) {
    where(:track_id.in => Track.visible_for_user(user).map{|t| t.id})
    .desc(:created_at)
  }

  scope :for_user, ->(user) {
    where(:user_id => user.id)
    .desc(:created_at)
  }

  after_create do
    Story.new(track: self.track, user: self.user, action: "added a comment").save
  end

  def author
    user.as_json(:noinclude => true, :only => :username, :methods => :email_hash)
  end

  def as_json(options={})
    super :methods => :author
  end
end
