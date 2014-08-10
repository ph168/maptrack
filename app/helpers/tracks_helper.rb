module TracksHelper
  def find_shared_track
    @track = Track.find_by_public_and_share_token(true, params[:share_token]) if params[:share_token]
  end
end
