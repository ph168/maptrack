class AddTimeToCoordinate < ActiveRecord::Migration
  def change
    add_column :coordinates, :time, :datetime
  end
end
