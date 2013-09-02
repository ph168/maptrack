class AddInfoToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :info, :text

    Track.all.each do |t|
      t.info = TrackInfo.new t
      t.save
    end
  end
end
