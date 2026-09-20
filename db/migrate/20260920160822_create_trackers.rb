class CreateTrackers < ActiveRecord::Migration[8.1]
  def change
    create_table :trackers do |t|
      t.string :nome
      t.string :url
      t.boolean :is_torrent

      t.timestamps
    end
    add_index :trackers, :url, unique: true
  end
end
