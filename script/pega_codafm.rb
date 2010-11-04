#!ruby19
# encoding: utf8
# author: rafael polo
# created_at 25.fev.2009
# updated_at 27.fev.2009

require 'open-uri'
require 'timeout'
require 'cgi'

class PegaCodafm < ActiveRecord::Base

  REGEX_ARTISTA = /<a href='\/artists\/([\d]+)'>\n<img/
  REGEX_ALBUM = /<a href='\/albums\/([\d]+)'>\n<img/
  
  @coda_user = User.find_by_username("codafm") || User.create(:username=>"Codafm", :email=>"robo@baixogavea.com", :senha=>"12codafm13", :info=>"Cato Coda.fm torrents", :confirmado=>1)

  def self.pega
    (17..23).each do |x| # a..z
      page = load_url("http://coda.fm/artists?page=#{x}")
      artistas = page.scan(REGEX_ARTISTA)
      artistas.uniq.each do |artista_id|
        pegaAlbuns(artista_id)
        puts
      end
    end
  end
  
  def self.pegaAlbuns(artista_id)
    page = load_url("http://coda.fm/artists/#{artista_id}")
    if page
      artist = page.scan(/<h2>(.*)<\/h2>/).to_s
      @artista = Banda.find_by_nome(artist) || Banda.create(:nome=>artist, :user=>@coda_user)
      puts "Artista: #{artist}"
      @artista.errors.each { |attr,msg| puts "#{attr} - #{msg}" } if @artista.errors
      albuns = page.scan(REGEX_ALBUM)
      albuns.uniq.each do |album_id|
        pegaAlbum(album_id)
      end
    end
  end
  
  def self.pegaAlbum(album_id)
    page = load_url("http://coda.fm/albums/#{album_id}")
    if page && @artista.id
      album = page.scan(/<h2 class='bottom'>(.*)<\/h2>/).to_s
      @album = Album.find_by_nome(album) || Album.create(:nome=>album, :banda=>@artista, :ano=>1900, :user=>@coda_user)
      href = page.scan(/class='link' href='(.*)' onClick/)
      puts "Album: #{album}"
      puts "Torrent: #{href}"
      pegaTorrent(href) if @album.id
    end
  end
	 
  def self.pegaTorrent(href)
    file = load_url("http://coda.fm#{href}")
    torrent = TorrentInfo.new(file) if file
    if file && torrent.ok?
      # torrent já foi criado?
      torrent_now = Torrent.find_by_fixhash(torrent.hash)
      if torrent_now
        puts "Torrent já existe."
      else
        #salva arquivo
        filename = File.join("..", "public", "torrents", torrent.hash)
        File.open(filename, 'w') {|f| f.write(file) }
        # cria torrent
        torrent_now = Torrent.create(:nome=>torrent.name, :fixhash=>torrent.hash, :size=>torrent.size)
        # cria arquivos
        torrent.files.each do |arquivo|
          filepath = arquivo["path"].join("/")
          size = arquivo["length"]
          path = filepath.rindex("/")
          if path
            # pega nome do arquivo do path
            pasta = path ? filepath[0..path-1] : ""
            arquivo = filepath[path+1..filepath.length]
          else
            arquivo = filepath
          end
          Arquivo.create(:torrent=>torrent_now, :size=>size, :nome=>arquivo, :pasta=>pasta)
        end        
        # cria link
        Link.create(:user=>@coda_user, :album=>@album, :torrent=>torrent_now, :is_torrent=>true)
      
        # cria trackers/torrents
        torrent.trackers.each do |tracker|
          tracker_exists = Tracker.find_by_url(tracker)
          tracker_now = tracker_exists ? tracker_exists : Tracker.create(:url=>tracker, :nome=>tracker, :is_torrent=>true)
          torrent_tracker_exists = TorrentsTracker.find_by_torrent_id_and_tracker_id(torrent_now.id, tracker_now.id)
          if !torrent_tracker_exists
            TorrentsTracker.create(:torrent=>torrent_now, :tracker=>tracker_now)
          end
        end
      end
    end
  end
	 
  def self.load_url(url)
    #puts "Carregando #{url}..."
    response=""
    begin
      timeout(8) do
        uri = URI.parse(url)
        response = uri.read if uri
      end
    rescue Exception=>error
      response = false
      puts "Erro: #{error}\n\n"
    end
    response
  end
	
end

PegaCodafm.pega


