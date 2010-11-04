ActionController::Routing::Routes.draw do |map|  
  map.root :controller => "bandas", :action=>"index"
  map.resources :links
  map.resources :torrents

  map.connect "login",  :controller => "users", :action=>"login"
  map.connect "logout",  :controller => "users", :action=>"logout"
  map.connect "stats.json", :controller => "stats", :action=>"stats"
  map.connect "novo_usuario",  :controller => "users", :action=>"novo"
  map.connect "pesquisa",  :controller => "pesquisa", :action=>"pesquisa"

  map.connect 'bandas/:letra',  :controller => "bandas", :action=>"index", :requirements => { :letra => /\w/ }
  map.connect 'nova_banda', :controller => "bandas", :action=>"new"
  map.connect 'usuario/:user', :controller => "users", :action=>"show"
  map.connect 'user/update/:id', :controller => "users", :action=>"update_status"

  map.resources :votos
  map.resources :users
  map.resources :bandas
  map.resources :albuns
  map.resources :votos

  map.connect 'torrents/upload', :controller=>"torrents", :action=>"upload"
  map.connect 'torrent/:fixhash', :controller => 'torrents', :action => 'show', :requirements => { :fixhash => /\w{40}/ }
  map.connect 'download/:fixhash', :controller => 'torrents', :action => 'download', :requirements => { :fixhash => /\w{40}/ }

  map.connect ':banda', :controller => "bandas", :action=>"show"
  map.connect ':banda/novo_album', :controller => "albuns", :action=>"new"
  map.connect ':banda/:album', :controller => "albuns", :action=>"show"
  map.connect ':banda/:album/novo_link', :controller => "links", :action=>"new"
  
  map.connect 'album/editar/:id', :controller => "albuns", :action=>"edit"
  map.connect 'album/excluir/:id', :controller => "albuns", :action=>"excluir"
  map.connect 'album/destroy/:id', :controller => "albuns", :action=>"destroy"

  map.connect 'sitemap.xml', :controller => "sitemap", :action => "sitemap"
  map.connect 'bg_search_plugin.xml', :controller=> "fake", :path=>"/bg_search_plugin.xml"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
