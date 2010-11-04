#!ruby19
# encoding: utf8
# author: rafael polo
# created_at 13.out.2009
# version 0.5 09.dez.2009

require 'bencode.rb'
require 'digest/sha1'
require 'open-uri'
require 'cgi'
require 'rubygems'
require 'json'
require 'timeout'

class TorrentInfo

	def initialize(data)
    begin
      @torrent = BEncode.load(data)
    rescue BEncode::DecodeError
      puts ".torrent inválido."
      return
    end
    # ter upload.log próprio!
    puts "Nome: #{self.name}"
    puts "Hash: #{self.hash}"
  end
	
  def name
    @torrent['info']['name'].strip
  end

  def announce_list
    list = []
    if @torrent['announce-list']
      @torrent['announce-list'].each do |announce|
        list << announce.to_s.gsub(":80", "").strip.to_s
      end
    end
    list
  end

  def announce
    @torrent['announce'].gsub(":80", "").strip
  end

  def info
    @torrent['info']
  end

  def url_encoded_hash
    url_encode(self.hash)
  end

  def pieces
    url_encode(self.info['pieces'])
  end

  def piece_length
    @torrent['info']['piece length'].to_i
  end
	
  def files
    @torrent['info']['files']
  end

  def size
    total_size = 0
    @torrent['info']['files'].each do |file|
      total_size += file['length']
    end
    total_size
  end

  def hash
    Digest::SHA1.hexdigest(self.info.bencode)
  end

  def url_encode(str)
    return CGI::escape([str].pack("H*"))
  end

  def self.encode(str)
    return CGI::escape([str].pack("H*"))
  end

  def ok?
    return !@torrent.nil? && !self.info.empty? && @torrent['info']['files']
  end

  # get torrentz and trackers_list trackers
  def trackers
    trackers = []
    # trackers = get_torrentz_trackers()
    # if trackers && !trackers.include?(self.announce)
    trackers << self.announce.to_s # add announce na lista
    #end
    self.announce_list.each do |announce|
      trackers << announce if !trackers.include?(announce) && !announce.include?("udp") # add se não tem e se não é udp
    end

    trackers
  end

  def self.load_url(url)
    puts "Consultando #{url}"
    response=""
    begin
      timeout(8) do # só tem 8 segundos para carregar
        uri = URI.parse(url)
        response = uri.read if uri
      end
    rescue Exception=>error
      response = false
      puts "Erro: #{error}\n\n"
    end
    response
  end
	
  def self.get_tracker_response(tracker, fixhash)
    tracker_response = {}
    tracker = tracker.to_s.gsub('announce', 'scrape')
    encoded_hash = self.encode(fixhash)
    encoded_response = self.load_url("#{tracker}?info_hash=#{encoded_hash}")
    return  if !encoded_response
    begin
      response = BEncode.load(encoded_response)    
    rescue Exception
      response = false
    end
    key = response['files'].keys[0] if response && response['files']
    if key
      result = response['files'][key]
      seeds = result['complete']
      leechs = result['downloaded']
      puts "Seeds: #{seeds} | Leechs: #{leechs}\n\n"
      tracker_response.store(:seeds, seeds)
      tracker_response.store(:leechs, leechs)
    else
      puts "Tracker não tem esse arquivo ou não informa."
    end
    tracker_response
  end

  def get_torrentz_trackers()
    list_url = TorrentInfo.load_url("http://www.torrentz.com/announce_#{self.hash}")
    trackers_list = list_url && list_url!="Not Found" ? list_url.split("\n\n") : []
    trackers_list
  end

end