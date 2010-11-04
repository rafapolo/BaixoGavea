class PesquisaController < ApplicationController

  def pesquisa
    pesquisa = params[:termo]
    if pesquisa && pesquisa!=""
      @pesquisa = pesquisa
      @bandas = Banda.find(:all, :conditions => ['nome LIKE ? ', "%#{@pesquisa}%"], :order => 'nome ASC')
      @albuns = Album.find(:all, :conditions => ['nome LIKE ? ', "%#{@pesquisa}%"], :order => 'nome ASC')
    else
      flash[:notice] = "Pesquisa não pode ser vazia."
      @bandas = []
      @albuns = []      
    end

    respond_to do |format|
      format.html
    end

  end

end
