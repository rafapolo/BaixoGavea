class Voto < ApplicationRecord
  belongs_to :link
  belongs_to :user

  validates :comentario, presence: true
  validates :ponto, presence: true, inclusion: { in: [-1, 1] }
end
