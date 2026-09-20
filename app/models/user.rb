class User < ApplicationRecord
  has_secure_password

  has_many :bandas, dependent: :destroy
  has_many :albums, dependent: :destroy
  has_many :links, dependent: :destroy
  has_many :votos, dependent: :destroy

  scope :confirmado, -> { where(confirmado: true) }
  scope :ativos, -> {
    joins(:links).group("users.id").order(Arel.sql("COUNT(links.id) DESC")).limit(10)
  }

  validates :username, presence: true, uniqueness: true, length: { in: 4..15 }
  validates :normalizado, uniqueness: true, allow_nil: true
  validates :email, presence: true, uniqueness: true,
    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :info, presence: true

  before_validation :normalizar_username

  private

  def normalizar_username
    return if username.blank?
    self.username = username.gsub(" ", "")
    self.normalizado = username.downcase
  end
end
