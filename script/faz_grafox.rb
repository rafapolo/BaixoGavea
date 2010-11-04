#!ruby19
# encoding: utf8
# author: rafael polo
# created_at 25.fev.2009
# updated_at 27.fev.2009

puts "Iniciando..."
require "graphviz"

class FazGrafox < ActiveRecord::Base

  puts "Fazendo gráfico..."
  g = GraphViz::new( "G", :type => "digraph")
  g.node[:color]    = "black"
  g.node[:style]    = "filled"
  g.node[:penwidth] = "1"
  g.node[:fontname] = "Trebuchet MS"
  g.node[:fontsize] = "8"
  g.node[:fillcolor]= "lightgray"
  g.node[:margin]   = "0.1"
  g[:overlap] = false

  beatles = Banda.find_by_nome("The Beatles")
  beatles_node = g.add_node(beatles.nome)
  beatles.albuns.each do |album|
    puts album.nome
    album_node = g.add_node(album.nome, :color=>"#ddaa66", :fillcolor=>"#ffeecc")
    g.add_edge(album_node, beatles_node)
    user = album.user.username
    user_exists =  g.get_node(user)
    user_node = user_exists ? user_exists : g.add_node(user, :color=>"darkblue", :fillcolor=>"#ccccff")
    g.add_edge(user_node, album_node)
  end

  if g
    puts "\nSalvando circo..."
    g.output(:png => "c1.png", :use=>:circo)
    puts "Salvando fdp..."
    g.output(:png => "c2.png", :use=>:fdp)
    puts "Salvando neato..."
    g.output(:png => "c3.png", :use=>:neato)
    puts "Salvando dot..."
    g.output(:png => "c4.png", :use=>:dot)
    puts "Salvo!"
  end
end