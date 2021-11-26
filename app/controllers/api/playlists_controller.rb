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

  def add_track
    track = Track.find_by(pid: params[:track_id])
    puts "@playlist.id #{@playlist.id}"
    puts "track.id #{track.id}"

    PlaylistTrack.create(playlist_id: @playlist.id, track_id: track.id)
    render json: track_to_response(track), status: :created
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
