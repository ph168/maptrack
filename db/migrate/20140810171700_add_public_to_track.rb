class AddPublicToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :public, :boolean
    add_column :tracks, :share_token, :string, unique: true
    Track.all.each do |track|
      track.public = false
      track.share_token = Devise.friendly_token
      track.save
    end
  end
end
