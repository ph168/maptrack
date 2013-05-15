class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :tracks

  has_many :friendships_as_initiator, :class_name => "Friendship", :foreign_key => "initiator_id"
  has_many :friendships_as_consumer, :class_name => "Friendship", :foreign_key => "consumer_id"
  def friendships
    friendships_as_initiator + friendships_as_consumer
  end

  def friendships_confirmed
    friendships.select{ |f| f.confirmed? }
  end

  def friends
    users = Array.new
    friendships_confirmed.each{ |f| users += f.users.select { |u| u.id != self.id } }
    users
  end

  def name
    if !username.nil?
      username
    else
      email.split('@')[0]
    end
  end

  def self.find_by_name name
    user = find_by_username(name)
    if user == nil
      where("email LIKE :prefix", prefix: "#{name}@%")[0]
    end
  end
end
