class AddPlaceToCoordinate < ActiveRecord::Migration
  def change
    add_column :coordinates, :place, :text
  end
end
