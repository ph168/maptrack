class Place
  include Mongoid::Document
  include Mongoid::ActiveRecordBridge

  belongs_to_record :coordinate

  field :data, type: Hash
end
