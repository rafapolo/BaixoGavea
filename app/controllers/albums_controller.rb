class AlbumsController < ApplicationController
  before_action :require_login, only: [:new, :create]

  def show
    banda = Banda.find_by(atalho: params[:banda])
    unless banda
      flash[:notice] = "Não existe essa banda aqui. Adicione!"
      redirect_to root_path and return
    end

    @album = banda.albums.find_by(atalho: params[:album])
    unless @album
      flash[:notice] = "Não existe esse álbum aqui. Adicione!"
      redirect_to banda_path(banda.atalho) and return
    end

    @banda = banda
  end

  def new
    @album = Album.new
    @banda = Banda.find_by(atalho: params[:banda])
  end

  def create
    @banda = Banda.find_by(atalho: params[:banda])
    @album = @banda.albums.new(album_params)
    @album.user = current_user

    if @album.save
      flash[:notice] = "O novo álbum foi adicionado."
      redirect_to album_path(banda: @banda.atalho, album: @album.atalho)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def album_params
    params.require(:album).permit(:nome, :ano)
  end
end
