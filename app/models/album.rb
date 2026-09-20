class Album < ApplicationRecord
  belongs_to :banda
  belongs_to :user
  has_many :links, -> { order(is_torrent: :desc) }, dependent: :destroy

  validates :nome, presence: true, length: { in: 2..55 }
  validates :ano, presence: true
  validates :nome, uniqueness: { scope: :banda_id, message: "já inserido para essa banda" }

  before_validation :gerar_atalho

  def self.ultimos(limit: 10)
    joins(:links)
      .group("albums.id")
      .order(Arel.sql("MAX(links.created_at) DESC"))
      .limit(limit)
  end

  private

  def gerar_atalho
    return if nome.blank?
    self.nome = nome.strip
    self.atalho = nome.parameterize
  end
end
