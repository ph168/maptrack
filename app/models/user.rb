class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :token
  attr_accessor :email_hash

  after_initialize do
    self.email_hash = Digest::MD5.hexdigest(self.email)
  end

  before_save do
    self.token = Devise.friendly_token if self.token.nil?
  end

  validates :username, :uniqueness => true
  validates :email, :uniqueness => true
  validates :token, :uniqueness => true

  scope :find_by_query, -> (query) {
    if query.length > 3
      where "email like ? or username like ?", "%#{query}%@%", "%#{query}%"
    else
      where "0=1"
    end
  }

  has_one_document :user_option
  has_many :tracks
  has_many :friendships_as_initiator, :class_name => "Friendship", :foreign_key => "initiator_id"
  has_many :friendships_as_consumer, :class_name => "Friendship", :foreign_key => "consumer_id"

  def friendships
    friendships_as_initiator + friendships_as_consumer
  end

  def friendships_confirmed
    friendships.select{ |f| f.confirmed? }
  end

  # Retrieve all users from the given friendships
  # default: confirmed friendships
  def friends(fships = friendships_confirmed)
    users = Array.new
    fships.each{ |f| users += f.users.select { |u| u.id != self.id } }
    users
  end

  # Retrieve all users from confirmed and unconfirmed friendships
  def all_friends
    friends friendships
  end

  def name
    if !username.nil?
      username
    else
      email.split('@')[0]
    end
  end

  def self.find_by_name name
    find_by_username(name) or where("email LIKE :prefix", prefix: "#{name}@%")[0]
  end

  def as_json(options={})
    super(:include => [
      {:friendships => {
          :include => [
            {:initiator => {:only => :username, :methods => :email_hash}},
            {:consumer => {:only => :username, :methods => :email_hash}}
          ]
        }
      },
      :friends => {:only => :username, :methods => :email_hash}],
    :methods => :email_hash)
  end
end
