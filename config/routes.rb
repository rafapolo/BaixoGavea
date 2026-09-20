Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "bandas#index"

  get "login" => "users#login", as: :login
  post "login" => "users#authenticate", as: :authenticate
  delete "logout" => "users#logout", as: :logout

  get "novo_usuario" => "users#novo", as: :novo_usuario
  post "usuarios" => "users#create", as: :usuarios
  get "usuario/:user" => "users#show", as: :usuario

  get "pesquisa" => "pesquisa#pesquisa", as: :pesquisa
  get "stats.json" => "stats#show", as: :stats
  get "sitexml" => "sitemap#sitemap", as: :sitemap

  get "bandas/:letra" => "bandas#index", as: :bandas_por_letra, constraints: { letra: /\w/ }
  get "nova_banda" => "bandas#new", as: :nova_banda
  post "bandas" => "bandas#create", as: :bandas

  resources :votos, only: [:index, :show, :create]
  resources :links, only: [:show, :new, :create]

  get "torrents" => "torrents#index", as: :torrents
  get "torrent/:fixhash" => "torrents#show", as: :torrent, constraints: { fixhash: /\w{40}/ }
  get "download/:fixhash" => "torrents#download", as: :download_torrent, constraints: { fixhash: /\w{40}/ }

  get ":banda/novo_album" => "albums#new", as: :novo_album
  post ":banda/albuns" => "albums#create", as: :criar_album
  get ":banda/:album/novo_link" => "links#new", as: :novo_link
  get ":banda/:album" => "albums#show", as: :album
  get ":banda" => "bandas#show", as: :banda
end
