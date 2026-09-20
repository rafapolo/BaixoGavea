class VotosController < ApplicationController
  before_action :require_login, only: [:create]

  def index
    @votos = Voto.all
  end

  def show
    @voto = Voto.find(params[:id])
  end

  def create
    @link = Link.find(params[:voto][:link_id])
    @voto = @link.votos.new(voto_params)
    @voto.user = current_user

    if @voto.save
      flash[:notice] = "Seu comentário foi adicionado. Obrigado #{current_user.username}!"
    else
      flash[:notice] = "Opz! Não deixe nenhum campo em branco."
    end

    redirect_to @link.is_torrent? ? torrent_path(@link.torrent.fixhash) : link_path(@link)
  end

  private

  def voto_params
    params.require(:voto).permit(:ponto, :comentario)
  end
end
