class CreateBandas < ActiveRecord::Migration[8.1]
  def change
    create_table :bandas do |t|
      t.string :nome
      t.string :atalho
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :bandas, :nome, unique: true
    add_index :bandas, :atalho, unique: true
  end
end
