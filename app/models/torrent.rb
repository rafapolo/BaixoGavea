class Torrent < ActiveRecord::Base
  has_many :torrents_tracker, :dependent => :destroy, :order=>"seeds DESC"
  has_many :trackers, :through => :torrents_tracker
  has_many :arquivos, :dependent => :destroy
  #has_one :piece, :dependent => :destroy
  has_one :link, :dependent => :destroy

  validates_uniqueness_of :fixhash
  validates_presence_of :nome, :size, :fixhash

  # soma os semeadores de todos os trackers
  def total_seeds
    total=0
    self.torrents_tracker.each do |tt|
      total+=tt.seeds
    end
    total
  end

  def before_destroy
    torrent_path = File.join("public", "torrents", self.fixhash)    
    File.delete(torrent_path) if File.exist?(torrent_path)
  end

  def filename
    return "#{self.nome}.torrent"
  end

  # melhor tracker
  def announce
    a = "http://tracker.openbittorrent.com/announce"
    if self.trackers && self.trackers>0
      a = self.torrents_tracker.first.tracker.url
    end
    a
  end

end