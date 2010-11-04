#!ruby19
# encoding: utf8
# author: rafael polo
# created_at: 02.mar.2010

require 'open-uri'
require 'timeout'
require 'htmlentities'

class PegaUmquetenha < ActiveRecord::Base

  REGEX_CALENDARIO = /umquetenha.org\/uqt\/\?m=([\d]+)/
  REGEX_POST = /<a href="http:\/\/umquetenha.org\/uqt\/\?p=([\d]+)"/
  REGEX_ALBUM = /(.*) – (.*) \(([\d]{4})\)/
  REGEX_CAPA1 = /width: 170px; height: 170px;" src="(.*\.jpg)"/i
  REGEX_CAPA2 = /src="(.*\.jpg)" style="margin: 0pt 10px 10px 0p/i
  REGEX_CAPA3 = /style="margin: 0pt 10px 10px 0p.*" src="(.*\.jpg)" alt/i
  REGEX_CAPA4 = /style="margin: 0px 10px 10px.*" alt="" src="(.*\.jpg)" border="0"/i
  REGEX_DOWNLOAD1 = /<a href="(.*)" target="blank"><span style/
  REGEX_DOWNLOAD2 = /<a target="blank" href="(.*)"><span style/
  
  @user = User.find_by_normalizado("umquetenha") || User.create(:username=>"UmQueTenha", :email=>"umquetenha@baixogavea.com", :senha=>"12umquetenha13", :info=>"Cato os links do umquetenha.org", :confirmado=>1)

  def self.pega
    @erros=@links=0
    decoder = HTMLEntities.new
    page = load_url("http://umquetenha.org/uqt")
    meses = page.scan(REGEX_CALENDARIO)
    meses.each do |mes|
      page_mes = load_url("http://umquetenha.org/uqt/?m=#{mes}")
      quando = page_mes.scan(/<h2 class="pagetitle">(.*)<\/h2>/)
      puts "\n#{quando}"
      posts = page_mes.scan(REGEX_POST)
      puts "#{posts.size} álbuns"
      posts.each do |post|
        page_album = load_url("http://umquetenha.org/uqt/?p=#{post}")
        album = page_album.scan(/<h2>(.*\([\d]{4}\))<\/h2>/)
        if album
          album = album.to_s
          album = decoder.decode(album)
          capa = page_album.scan(REGEX_CAPA1).to_s
          capa = page_album.scan(REGEX_CAPA2).to_s if capa==""
          capa = page_album.scan(REGEX_CAPA3).to_s if capa==""
          capa = page_album.scan(REGEX_CAPA4).to_s if capa==""
          capa = nil if capa=="" || !capa.match(/^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix)
          download = page_album.scan(REGEX_DOWNLOAD1).to_s
          download = page_album.scan(REGEX_DOWNLOAD2).to_s if download==""
          album_info = album.scan(REGEX_ALBUM)
          if album_info && album_info.first
            album_info = album_info.first
            artista = album_info[0]
            album = album_info[1]
            ano = album_info[2]
            if album!="" && capa!="" && artista!="" && album!="" && ano!="" && download!=""
              puts "Artista: #{artista}"
              @artista = Banda.find_by_nome(artista) || Banda.create(:nome=>artista, :user=>@user)
              puts "Album: #{album}"
              puts "Ano: #{ano}"
              puts "Capa: #{capa}"
              @album = Album.find_by_nome(album) || Album.create(:nome=>album, :banda=>@artista, :ano=>ano, :user=>@user, :image_url=>capa) if @artista.id
              puts "Download: #{download}"
              @link = Link.find_by_url(album) || Link.create(:url=>download, :album=>@album, :user=>@user) if @album.id
              @links+=1 if @link.id
              puts
            else
              @erros+=1
              puts "Erro: Faltou dados!\n===================="
              puts "Artista: #{artista}"
              puts "Album: #{album}"
              puts "Ano: #{ano}"
              puts "Capa: #{capa}"
              puts "Download: #{download}\n===================="
              puts
            end
          end
        end
      end
    end
    puts "\n====================\nCompleto!\n====================\n"
    puts "Erros: #{@erros}"
    puts "Links: #{@links}"
    puts "\n===================="
  end
  
  def self.load_url(url)
    response=""
    begin
      timeout(15) do
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

PegaUmquetenha.pega

