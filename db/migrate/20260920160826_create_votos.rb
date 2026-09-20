class CreateVotos < ActiveRecord::Migration[8.1]
  def change
    create_table :votos do |t|
      t.references :link, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :ponto
      t.text :comentario

      t.timestamps
    end
  end
end
