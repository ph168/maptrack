class AddInfoToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :info, :text

    Track.all.each do |t|
      t.info = TrackInfo.new t
      t.save
      t.coordinates.each do |c|
        c.user_id = t.user_id
        c.save
      end
    end
  end
end
