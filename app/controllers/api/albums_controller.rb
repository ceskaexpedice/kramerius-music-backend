class Api::AlbumsController < Api::ApiController
 
  def index
    results = []
    Album.all.each do |album|
      results.push to_response(album)
    end
    render json: results, status: :ok 
  end


  private

  def to_response(album)
    {
      pid: album.pid,
      title: album.title,
      date: album.date,
      is_private: album.is_private,
      source: album.source,
      artists: album.artists.split(";;"),
      genres: album.genres.split(";;")
    }
  end


end
