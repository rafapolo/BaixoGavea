class LinksController < ApplicationController
  before_action :require_login, only: [:new, :create]

  def show
    @link = Link.find(params[:id])
    @votos = @link.votos.order(created_at: :asc)
    @voto = Voto.new
  end

  def new
    @link = Link.new
    banda = Banda.find_by(atalho: params[:banda])
    @album = banda&.albums&.find_by(atalho: params[:album])
  end

  def create
    banda = Banda.find_by(atalho: params[:banda])
    @album = banda&.albums&.find_by(atalho: params[:album])
    @link = @album.links.new(link_params)
    @link.user = current_user

    if @link.save
      flash[:notice] = "O novo link foi adicionado. Obrigado #{current_user.username}!"
      redirect_to album_path(banda: banda.atalho, album: @album.atalho)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def link_params
    params.require(:link).permit(:url)
  end
end
