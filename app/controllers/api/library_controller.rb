class Api::LibraryController < Api::ApiController
  before_action :require_logged_in

  def add_album
    album = Album.find_by(pid: params[:album_id])
    if AlbumsLibrary.where(album: album, user: current_user).count == 0
      AlbumsLibrary.create(album: album, user: current_user)
    end
    render json: { message: "Ok" }, status: :created
  end

  def remove_album
    album = Album.find_by(pid: params[:album_id])
    AlbumsLibrary.where(album: album, user: current_user).destroy_all
    render json: { message: "Ok" }, status: :created
  end

  def albums
    results = AlbumsLibrary.where(user: current_user).joins(:album).pluck("albums.pid")
    render json: results, status: :ok 
  end



  def add_artist
    name = params[:name]
    if ArtistsLibrary.where(artist: name, user: current_user).count == 0
      ArtistsLibrary.create(artist: name, user: current_user)
    end
    render json: { message: "Ok" }, status: :created
  end

  def remove_artist
    name = params[:name]
    ArtistsLibrary.where(artist: name, user: current_user).destroy_all
    render json: { message: "Ok" }, status: :created
  end

  def artists
    results = ArtistsLibrary.where(user: current_user).pluck(:artist)
    render json: results, status: :ok 
  end





end
