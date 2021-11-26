class CreatePlaylists < ActiveRecord::Migration[5.2]
  def change
    create_table :playlists do |t|
      t.string :title
      t.references :user, foreign_key: true
      t.string :uid

      t.timestamps
    end
  end
end
