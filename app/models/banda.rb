class Banda < ApplicationRecord
  belongs_to :user
  has_many :albums, dependent: :destroy

  validates :nome, presence: true, uniqueness: true, length: { in: 2..55 }
  validates :atalho, presence: true, uniqueness: true

  before_validation :gerar_atalho

  def self.find_by_letra(letra)
    if letra == "9"
      where("nome GLOB ?", "[0-9]*").order(:nome)
    else
      where("nome LIKE ?", "#{letra}%").order(:nome)
    end
  end

  def self.algumas(limit: 10)
    order(Arel.sql("RANDOM()")).limit(limit)
  end

  private

  def gerar_atalho
    return if nome.blank?
    self.nome = nome.strip
    self.atalho = nome.parameterize
  end
end
