class AddElevationToCoordinate < ActiveRecord::Migration
  def change
    add_column :coordinates, :elevation, :float
  end
end
