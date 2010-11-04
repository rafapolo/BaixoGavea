#!ruby19
# encoding: utf8
# author: rafael polo
# created_at 25.fev.2009
# updated_at 27.fev.2009

puts "Iniciando..."
require "graphviz"

class FazGrafo < ActiveRecord::Base

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

  miris = User.find_by_username("matiris")
  miris_node = g.add_node(miris.username)
  miris.bandas.each do |banda|
    b = g.add_node(banda.nome, :color=>"darkblue", :fillcolor=>"#ccccff")
    g.add_edge(miris_node, b)
  end
  miris.albuns.each do |album|
    a = g.add_node(album.nome, :color=>"#ddaa66", :fillcolor=>"#ffeecc")
    b_exists = g.get_node(album.banda.nome)
    if b_exists
    b_node =  b_exists
    else
      b_node = g.add_node(album.banda.nome, :color=>"darkblue", :fillcolor=>"#ccccff")
      dono = g.add_node(album.banda.user.username)
      g.add_edge(dono, b_node)
    end
    g.add_edge(a, b_node)
  end

  if g
    puts "\nSalvando circo..."
    g.output(:png => "result-circo.png", :use=>:circo)
    #puts "Salvando fdp..."
    #g.output(:png => "result-fdp.png", :use=>:fdp)
    #puts "Salvando neato..."
    #g.output(:png => "result-neato.png", :use=>:neato)
    #puts "Salvando dot..."
    #g.output(:png => "result-dot.png", :use=>:dot)
    puts "Salvo!"
  end
end




