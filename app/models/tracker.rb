class Tracker < ApplicationRecord
  has_many :links

  validates :url, presence: true, uniqueness: true
end
