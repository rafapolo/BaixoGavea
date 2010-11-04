class TorrentsTracker < ActiveRecord::Base
  belongs_to :torrent
  belongs_to :tracker

  validates_presence_of :torrent, :tracker

  def before_create
    return false if TorrentsTracker.find_all_by_tracker_id_and_torrent_id(self.tracker.id, self.torrent.id).count > 0
    atualiza
  end

  def atualiza
    result = TorrentInfo.get_tracker_response(self.tracker.url, self.torrent.fixhash)
    # só add se tiver seed e leech
    if result && result[:seeds] && result[:leechs] && (result[:seeds]>=0 && result[:leechs]>=0)
      self.seeds = result[:seeds]
      self.leechs = result[:leechs]
    else
      # remove se não teve resultado
      self.destroy if self.id
      return false
    end
  end

end
