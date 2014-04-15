class UserOption
  include Mongoid::Document

  belongs_to_record :user

  field :language
  field :time_zone
  field :system_of_measurement
end
