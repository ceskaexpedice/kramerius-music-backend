class Api::TracksController < Api::ApiController
 
  def index
    results = []
    Album.find_by(pid: params[:album_id]).tracks.order(position: :asc).each do |track|
      results.push to_response(track)
    end
    render json: results, status: :ok 
  end


  def search
    results = []
    q = params[:query]
    limit = params[:limit] || 30
    tracks = Track.where("title ILIKE ?", "%#{q}%")
    if params[:accessibility] == "public"
      tracks = tracks.where(is_private: false)
    end
    tracks.limit(limit).each do |track|
      results.push to_response(track)
    end
    render json: results, status: :ok 
  end


  private

  def to_response(track)
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
