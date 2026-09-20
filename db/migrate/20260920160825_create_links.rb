class CreateLinks < ActiveRecord::Migration[8.1]
  def change
    create_table :links do |t|
      t.string :url
      t.boolean :is_torrent
      t.references :album, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :tracker, null: true, foreign_key: true
      t.references :torrent, null: true, foreign_key: true

      t.timestamps
    end
  end
end
