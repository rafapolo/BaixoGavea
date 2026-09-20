class PesquisaController < ApplicationController
  def pesquisa
    termo = params.dig(:pesquisar, :txt)

    if termo.present?
      @pesquisa = termo
      @bandas = Banda.where("nome LIKE ?", "%#{termo}%").order(:nome)
      @albuns = Album.where("nome LIKE ?", "%#{termo}%").order(:nome)
    else
      flash.now[:notice] = "Pesquisa não pode ser vazia."
      @bandas = Banda.none
      @albuns = Album.none
    end
  end
end
