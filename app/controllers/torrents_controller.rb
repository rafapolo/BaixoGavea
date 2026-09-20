class TorrentsController < ApplicationController
  def index
    @torrents = Torrent.order(created_at: :desc)
  end

  def show
    @torrent = Torrent.find_by(fixhash: params[:fixhash])
    unless @torrent
      flash[:notice] = "Não existe esse torrent."
      redirect_to(request.referer || root_path) and return
    end

    @votos = @torrent.link.votos.order(created_at: :asc)
    @voto = Voto.new
  end

  def download
    @torrent = Torrent.find_by(fixhash: params[:fixhash])
    torrent_path = Rails.root.join("storage", "torrents", @torrent&.fixhash.to_s)

    unless @torrent && File.exist?(torrent_path)
      flash[:notice] = "Não há esse torrent."
      redirect_to(request.referer || root_path) and return
    end

    send_file torrent_path, filename: @torrent.filename, type: "application/x-bittorrent"
  end
end
