class Link < ApplicationRecord
  belongs_to :album
  belongs_to :user
  belongs_to :tracker, optional: true
  belongs_to :torrent, optional: true
  has_many :votos, dependent: :destroy

  validates :url, presence: true, uniqueness: true,
    format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }

  after_create :criar_voto_inicial

  private

  def criar_voto_inicial
    votos.create!(user: user, ponto: 1, comentario: "Novo liame adicionado.")
  end
end
