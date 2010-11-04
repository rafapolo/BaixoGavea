#!ruby19
# encoding: utf8
# author: rafael polo
# created_at 18.06.2010

class GeraRDF < ActiveRecord::Base

  puts "<?xml version=\"1.0\"?>"
  puts
  puts "<rdf:RDF"
  puts "xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\""
  puts "xmlns:album=\"http://www.baixogavea.com/rdf/album#\">"
  puts

  # pega os primeiros 500 álbuns que tenha link
  Album.find(:all, :order=>"created_at ASC").each do |album|
    if album.links.last && album.banda
      puts "<rdf:Description rdf:about=\"#{album.nome}\">"
      puts "\t<album:banda>#{album.banda.nome}</album:banda>"
      puts "\t<album:ano>#{album.ano}</album:ano>"
      puts "\t<album:usuario>#{album.user.username}</album:usuario>"
      puts "\t<album:download>#{album.links.last.url}</album:download>"
      #puts "\t<album:criado>#{album.created_at.strftime("%Y-%m-%d")}</album:criado>"
      puts "</rdf:Description>"
    end
  end

  puts
  puts "</rdf:RDF>"
  puts

end