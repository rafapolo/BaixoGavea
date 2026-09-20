class BandasController < ApplicationController
  before_action :require_login, only: [:new, :create]

  def index
    letra = params[:letra]
    @bandas = letra ? Banda.find_by_letra(letra) : []

    @bandas_count = Banda.count
    @albuns_count = Album.count
    @users_count = User.confirmado.count

    @algumas_bandas = Banda.algumas
    @ultimos_albuns = Album.ultimos
    @usuarios_ativos = User.ativos
  end

  def show
    @banda = Banda.find_by(atalho: params[:banda])

    unless @banda
      flash[:notice] = "Não existe essa banda aqui. Adicione!"
      redirect_to root_path and return
    end

    @banda_albuns = @banda.albums.order(:ano)
  end

  def new
    @banda = Banda.new
  end

  def create
    @banda = Banda.new(banda_params)
    @banda.user = current_user

    if @banda.save
      flash[:notice] = "A nova banda foi adicionada."
      redirect_to novo_album_path(banda: @banda.atalho)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def banda_params
    params.require(:banda).permit(:nome)
  end
end
