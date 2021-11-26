class Playlist < ApplicationRecord
  belongs_to :user
  has_many :playlist_tracks
  has_many :tracks, through: :playlist_tracks

  before_create :assign_uid
  before_save :clean_title

  private
  def assign_uid
    self.uid = SecureRandom.alphanumeric(10).downcase
  end

  def clean_title
    self.title.strip!
  end

end
