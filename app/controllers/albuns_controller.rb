class AlbunsController < ApplicationController
caches_page :show

  def show
    banda = Banda.find_by_atalho(params[:banda])

    unless banda
      flash[:notice] = "Não existe essa banda aqui. Adicione!"
      redirect_to("/")
      return
    end

    @album = Album.find_by_atalho_and_banda_id(params[:album], banda)
    unless @album
      flash[:notice] = "Não existe esse álbum aqui. Adicione!"
      redirect_to("/"+banda.atalho)
      return
    end
    @page_title = banda.nome + " | " + @album.nome

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @album }
    end
  end

  def new
    @album = Album. new
    @banda = Banda.find_by_atalho(params[:banda])

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @album = Album.find(params[:id])
    if @album.user.id != session[:user]
      flash[:notice] = "Você só pode editar as bandas que adicionou."
      redirect_to("/")
      return
    end
  end

  def new_album_link(album)
    "/#{album.banda.atalho}/#{album.atalho}/novo_link"
  end

  def create
    album = params[:album]
    album["ano"] = album["ano(1i)"]
    album.delete("ano(1i)")
    album.delete("ano(2i)")
    album.delete("ano(3i)")
    @album = Album.new(album)
    @banda = @album.banda
    @album.user_id = session[:user]
    
    respond_to do |format|
      if @album.save
        flash[:notice] = "O novo álbum foi adicionado."
        format.html { redirect_to(new_album_link(@album), :banda=>@album.banda.atalho, :album=>@album.atalho) }
        format.xml  { render :xml => @album, :status => :created, :location => @album.atalho }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @album = Album.find(params[:id])

    if @album.user.id != session[:user]
      flash[:notice] = "Você só pode editar as bandas que adicionou."
      redirect_to("/")
      return
    end

    respond_to do |format|
      album = params[:album]
      album["ano"] = album["ano(1i)"]
      album.delete("ano(1i)")
      album.delete("ano(2i)")
      album.delete("ano(3i)")
      if @album.update_attributes(album)
        flash[:notice] = 'O Álbum foi editado com sucesso.'
        format.html { redirect_to("/#{@album.banda.atalho}/#{@album.atalho}/") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # pré
  def excluir
    @album = Album.find(params[:id])
    #album.destroy
    flash[:notice] = "Hey! Mesmo, mesmo, #{session[:username]}?"
  end

  def destroy
    @album = Album.find(params[:id])
    user = @album.user
    if session[:user] == user.id
      @album.destroy
      flash[:notice] = 'Álbum excluído!'
    else
      flash[:notice] = 'Você só pode excluir o que adicionou!'
    end

    puts user_path(user)
    respond_to do |format|
      format.html {redirect_to("/usuario/#{user.username}")}
    end
  end

end
