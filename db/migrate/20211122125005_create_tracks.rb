class CreateTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :tracks do |t|
      t.references :album, foreign_key: true
      t.string :pid
      t.string :title
      t.string :unit
      t.boolean :is_private
      t.integer :position
      t.string :source

      t.timestamps
    end
  end
end
