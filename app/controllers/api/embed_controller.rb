class Api::EmbedController < Api::ApiController
 
  def show
    track = Track.find_by(pid: params[:pid])
    render json: {
      track: track_to_response(track),
      album: album_to_response(track.album)
    }, status: :ok 
  end


  private

  def album_to_response(album)
    {
      pid: album.pid,
      title: album.title,
      date: album.date,
      source: album.source,
      artists: album.artists.split(";;")
    }
  end


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


end
