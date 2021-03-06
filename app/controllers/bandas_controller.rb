class BandasController < ApplicationController
  caches_page :index, :show

  # GET /bandas
  # GET /bandas.xml
  def index
    letra = params[:letra]
    @bandas = letra ? Banda.find_by_letra(letra ) : []

    @bandas_count = Banda.count
    @albuns_count = Album.count
    @users_count = User.confirmado.count

    @algumas_bandas = Banda.find(:all, :offset => (Banda.count * rand - 10).to_i ,:limit=>10)
    @ultimos_albuns = Album.ultimos
    @usuarios_ativos = User.ativos
    #@dominios_utilizados = Link.utilizados

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bandas }
    end
  end

  # GET /bandas/1
  # GET /bandas/1.xml
  def show
    @banda = Banda.find_by_atalho(params[:banda])
    
    if !@banda
      flash[:notice] = "Não existe essa banda aqui. Adicione!"
      redirect_to("/")
      return
    else
      @page_title = @banda.nome
    end
    
    @banda_albuns = Album.find_all_by_banda_id(@banda.id, :order=>"ano")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @banda }
    end
  end

  # GET /bandas/new
  # GET /bandas/new.xml
  def new
    @banda = Banda.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @banda }
    end
  end

  # GET /bandas/1/edit
  def edit
    @banda = Banda.find(params[:id])
  end

  # POST /bandas
  # POST /bandas.xml
  def create
    @banda = Banda.new(params[:banda])
    @banda.user_id = session[:user]
    
    respond_to do |format|
      if @banda.save
        flash[:notice] = "A nova banda foi adicionada."
        format.html { redirect_to("/#{@banda.atalho}/novo_album", :banda=>@banda) }
      else
        format.html { render :action => "new" }
      end
    end
  end

end
