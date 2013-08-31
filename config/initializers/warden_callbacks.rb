Warden::Manager.after_authentication do |user, auth, opts|
  user.tracks.each do |track|
    track.close! if track.old?
  end
end
