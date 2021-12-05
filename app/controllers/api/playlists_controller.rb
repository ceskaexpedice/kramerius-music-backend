class Api::PlaylistsController < Api::ApiController
  before_action :require_logged_in
  before_action :set_playlist, except: [:index, :create]

  def index
    results = []
    Playlist.where(user: current_user).each do |playlist|
      results.push(to_response(playlist))
    end
    render json: results, status: :ok 
  end

  def show 
    render json: to_response(@playlist, true), status: :ok 
  end

  def create
    playlist = Playlist.new(playlist_params)
    playlist.user = current_user
    playlist.save
    render json: to_response(playlist), status: :created
  end

  def update
    @playlist.update(playlist_params)
    render json: to_response(@playlist), status: :ok
  end

  def add_track
    track = Track.find_by(pid: params[:track_id])
    if PlaylistTrack.where(playlist_id: @playlist.id, track_id: track.id).count == 0
      PlaylistTrack.create(playlist_id: @playlist.id, track_id: track.id)
      render json: { message: "Ok", status: 1 }, status: 200
    else
      render json: { message: "Track already in playlist", status: 2 }, status: 200
    end
  end

  def remove_track
    track = Track.find_by(pid: params[:track_id])
    PlaylistTrack.where(playlist_id: @playlist.id, track_id: track.id).destroy_all
    render json: { message: "Ok" }, status: :created
  end

  def destroy
    @playlist.destroy
    render json: { message: "Ok" }, status: :ok
  end

  private

    def track_to_response(track)
      {
        pid: track.pid,
        title: track.title,
        unit: track.unit,
        source: track.source,
        album_pid: track.album.pid,
        is_private: track.is_private
      }
    end

    def playlist_params
      params.require(:playlist).permit(:title)
    end

    def set_playlist
      @playlist = Playlist.find_by(uid: params[:id])
      render status: 403, json: { message: "Forbidden" } if @playlist.user != current_user
    end  

    def to_response(playlist, detail = false)
      result = {
        uid: playlist.uid,
        title: playlist.title
      }
      if detail
        tracks = []
        playlist.playlist_tracks.order(created_at: :asc).each do |pt|
          tracks.push(track_to_response(pt.track))
        end
        result["tracks"] = tracks
      end
      return result
    end

end
