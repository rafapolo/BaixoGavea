class LinksController < ApplicationController
caches_page :show

  # GET /links/1
  # GET /links/1.xml
  def show
    @link = Link.find(params[:id])
    @votos = Voto.find_all_by_link_id(@link.id, {:order=>"created_at ASC"})
    @voto = Voto.new

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @link }
    end
  end

  # GET /links/new
  # GET /links/new.xml
  def new
    @link = Link.new
    banda = Banda.find_by_atalho(params[:banda])
    @album = Album.find_by_atalho_and_banda_id(params[:album], banda)
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @link }
    end
  end

  # POST /links
  # POST /links.xml
  def create
    @link = Link.new(params[:link])
    @album = @link.album

      # mas camarada adiciona .torrent como url de link
      if @link.url.ends_with?(".torrent")
        flash[:notice] = "Opz! Esse é um link para um .torrent, não o link para o arquivo."
      end

    respond_to do |format|
      if @link.save
        flash[:notice] = "O novo link foi adicionado. Obrigado #{session[:username]}!"
        format.html { redirect_to("/#{@album.banda.atalho}/#{@album.atalho}") }
        format.xml  { render :xml => @link, :status => :created, :location => @link }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

end
