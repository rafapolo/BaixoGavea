class VotosController < ApplicationController

  def show
    @voto = Voto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @voto }
    end
  end

  # GET /pontos/new
  # GET /pontos/new.xml
  def new
    @voto = Voto.new

    # respond_to do |format|
    #  format.html # new.html.erb
    #  format.xml  { render :xml => @ponto }
    #end
  end

  # GET /pontos/1/edit
  def edit
    @voto = Voto.find(params[:id])
  end

  # POST /pontos
  # POST /pontos.xml
  def create
    @voto = Voto.new(params[:voto])

    respond_to do |format|
      if session[:user]==nil
        flash[:notice] = "Você precisa se autenticar."
        session[:href] = request.referer
        redirect_to("/login")
        return
      end

      if !@voto.save
        #erro = (!@voto.comentario || !@voto.ponto) ? "Opz! Não deixe nenhum campo em branco." : 'Opz! Você só pode votar uma vez por link.'
        flash[:notice] = "Opz! Não deixe nenhum campo em branco."
      else
        flash[:notice] =  "Seu comentário foi adicionado. Obrigado #{session[:username]}!"
      end
      format.html {
        path = @voto.link.is_torrent? ? ("/torrent/"+@voto.link.torrent.fixhash) : link_path(@voto.link)
        redirect_to(path)        
      }
    end
  end

end
