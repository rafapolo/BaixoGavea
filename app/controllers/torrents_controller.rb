class TorrentsController < ApplicationController
caches_page :show

  def show
    @torrent = Torrent.find_by_fixhash(params[:fixhash])
    if @torrent
      @votos = Voto.find_all_by_link_id(@torrent.link.id, {:order=>"created_at ASC"})
      @voto = Voto.new
    else
      flash[:notice] = "Não existe esse torrent."
      redirect_to(request.referer ? request.referer : "/")
      return
    end

    respond_to do |format|
      format.html
    end
  end

  def download
    @torrent = Torrent.find_by_fixhash(params[:fixhash])
    if !@torrent
      flash[:notice] = "Esse torrent não foi enviado"
      redirect_to(request.referer ? request.referer : "/")
    end
    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] = ''
      headers['Cache-Control'] = ''
    else
      headers['Pragma'] = 'no-cache'
      headers['Cache-Control'] = 'no-cache, must-revalidate'
    end
    torrent_filename = File.join("public/torrents", @torrent.fixhash)
    unless File.exists?(torrent_filename)
      puts torrent_filename
      flash[:notice] = "Não há esse torrent"
      redirect_to(request.referer ? request.referer : "/")
    else
      output = File.open(torrent_filename).read
      send_data(output, :filename => @torrent.filename, :type => "application/x-bittorrent", :disposition => "attachment")
    end
  end

  def upload
    login
    #url = params[:torrents][:URL]
    @album = Album.find(params[:album_id])
    data = params[:upload]
    if !data
      flash[:notice] = "Arquivo deve ser .torrent"
      redirect_to(request.referer)
      return
    else
      uploaded = data[:torrent_file]
    end
    # valida
    if !uploaded || !uploaded.original_filename || !uploaded.original_filename.ends_with?(".torrent")
      flash[:notice] = "Arquivo deve ser .torrent"
      redirect_to(request.referer)
      return
    end
    # não pode ser maior que 1mb
    if uploaded.size > 1.megabytes
      flash[:notice] = "Arquivo .torrent não pode ser maior que 1 megabyte."
      redirect_to(request.referer)
      return
    end
    uploaded_file = uploaded.read
    torrent = TorrentInfo.new(uploaded_file)
    if torrent.ok?
      # torrent já foi criado?
      torrent_now = Torrent.find_by_fixhash(torrent.hash)
      if torrent_now
        flash[:notice] = "Torrent já existe."
        redirect_to(request.referer)
        return
      else

        #salva arquivo
        filename = File.join("public", "torrents", torrent.hash)
        File.open(filename, 'w') {|f| f.write(uploaded_file) }

        # cria torrent
        torrent_now = Torrent.create(:nome=>torrent.name, :fixhash=>torrent.hash, :size=>torrent.size)
        # Piece.create(:torrent=>torrent_now, :pieces=>torrent.pieces, :length=>torrent.piece_length)

        # cria arquivos
        torrent.files.each do |arquivo|
          filepath = arquivo["path"].join("/")
          size = arquivo["length"]
          path = filepath.rindex("/")
          if path
            pasta = path ? filepath[0..path-1] : ""
            arquivo = filepath[path+1..filepath.length]
          else
            arquivo = filepath
          end
          Arquivo.create(:torrent=>torrent_now, :size=>size, :nome=>arquivo, :pasta=>pasta)
        end
        
        # cria link
        Link.create(:user_id=>session[:user], :album_id=>@album.id, :torrent_id=>torrent_now.id, :is_torrent=>true)
      end

      # cria trackers/torrents
      torrent.trackers.each do |tracker|
        tracker_exists = Tracker.find_by_url(tracker)
        tracker_now = tracker_exists ? tracker_exists : Tracker.create(:url=>tracker, :nome=>tracker, :is_torrent=>true)
        torrent_tracker_exists = TorrentsTracker.find_by_torrent_id_and_tracker_id(torrent_now.id, tracker_now.id)
        if !torrent_tracker_exists
          TorrentsTracker.create(:torrent=>torrent_now, :tracker=>tracker_now)
        end
      end

      flash[:notice] = "Torrent adicionado, obrigado."
      
    else
      flash[:notice] = "Torrent inválido."
    end

    respond_to do |format|
      format.html { redirect_to("/#{@album.banda.atalho}/#{@album.atalho}") }
    end
    
  end

end
