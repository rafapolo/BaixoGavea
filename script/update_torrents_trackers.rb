# Rafael Polo
# 18.fev.2010
# criar log

class UpdateTorrentsTrackers < ActiveRecord::Base
  puts
  Torrent.all.each do |torrent|
    torrent_path = File.join("baixogavea.com/rails_app", "public", "torrents", torrent.fixhash)
    if File.exist?(torrent_path)
      torrent_file = File.open(torrent_path).read
      torrent_info = TorrentInfo.new(torrent_file)
      if torrent_info.ok?
        torrent_trackers = torrent_info.trackers
        torrent_trackers.each do |tracker|
          tracker_exists = Tracker.find_by_url(tracker)
          tracker_now = tracker_exists ? tracker_exists : Tracker.create(:url=>tracker, :nome=>tracker, :is_torrent=>true)
          torrent_tracker_exists = TorrentsTracker.find_by_torrent_id_and_tracker_id(torrent.id, tracker_now.id)
          if torrent_tracker_exists
            # update
            torrent_tracker_exists.atualiza
          else
            # create
            TorrentsTracker.create(:torrent=>torrent, :tracker=>tracker_now)
          end
        end
        puts
      else
        puts "Erro: #{torrent_path} é inválido."
      end
    else
      puts "Erro: #{torrent_path} não existe."
    end
  end

end
