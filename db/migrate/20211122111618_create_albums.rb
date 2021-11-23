class CreateAlbums < ActiveRecord::Migration[5.2]
  def change
    create_table :albums do |t|
      t.string :pid
      t.string :title
      t.string :genres
      t.string :artists
      t.string :date
      t.boolean :is_private
      t.string :source

      t.timestamps
    end
  end
end
