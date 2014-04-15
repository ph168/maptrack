class UserOption
  include Mongoid::Document
  include Mongoid::ActiveRecordBridge

  belongs_to_record :user

  field :locale, type: String
  field :time_zone, type: Integer
end
