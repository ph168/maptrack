class CreateCoordinates < ActiveRecord::Migration
  def change
    create_table :coordinates do |t|
      t.integer :track_id
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
