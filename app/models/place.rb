class Place
  include Mongoid::Document
  include Mongoid::ActiveRecordBridge

  belongs_to_record :coordinate
  has_many :comments

  field :data, type: Hash
end
