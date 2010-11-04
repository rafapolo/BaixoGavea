class PesquisaController < ApplicationController

  def pesquisa
    pesquisa = params[:pesquisar]
    if pesquisa && pesquisa[:txt]!=""
      @pesquisa = pesquisa[:txt]
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
