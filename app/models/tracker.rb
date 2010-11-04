class Tracker < ActiveRecord::Base
  has_many :torrents_trackers, :dependent => :destroy, :order=>"seeds DESC"
  has_many :torrents, :through => :torrents_trackers
  has_many :links

  validates_presence_of :url
  validates_uniqueness_of :url

end
