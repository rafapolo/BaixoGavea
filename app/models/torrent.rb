class Torrent < ApplicationRecord
  has_one :link, dependent: :destroy

  validates :nome, presence: true
  validates :size, presence: true
  validates :fixhash, presence: true, uniqueness: true

  def filename
    "#{nome}.torrent"
  end
end
