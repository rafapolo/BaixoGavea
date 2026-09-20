class CreateTorrents < ActiveRecord::Migration[8.1]
  def change
    create_table :torrents do |t|
      t.string :nome
      t.string :fixhash
      t.integer :size

      t.timestamps
    end
    add_index :torrents, :fixhash, unique: true
  end
end
