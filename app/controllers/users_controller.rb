class UsersController < ApplicationController

  def login
    if params[:user]
      log_user = params[:user]
      @user = User.find_by_username_and_confirmado(log_user[:username], "1")
      if !@user
        flash[:notice] = "Usuário não existe."
      else
      	if @user.senha == log_user[:senha]
          session[:user] = @user.id
          session[:username] = @user.username
          session[:logged] = true
          flash[:notice] = "Bem-Vindo #{@user.username}!"
          @user.lastlogin_at = DateTime.now
          @user.save
          redirect_to session[:href] ? session[:href] : "/"
        	return true
        else
          flash[:notice] = "Senha incorreta!"
        end
      end
    end

    respond_to do |format|     
      format.html
    end
  end

  def logout
    session[:user] = nil
    session[:username] = nil
    session[:logged] = false
    flash[:notice] = "Tchau!"
    redirect_to request.referrer
  end

  def show
    @user = User.find_by_username_and_confirmado(params[:user], "1")
    
    if @user==nil && params[:valid]
      # validação
      user_not_confirmed = User.find_by_username(params[:user])
      if user_not_confirmed
        validation = user_not_confirmed.gera_cod_valid
        if params[:valid] == validation
          user_not_confirmed.confirmado=1
          user_not_confirmed.save
          user = user_not_confirmed
          # agora tá confirmado
          flash[:notice] = "Ativado! Bem-Vindo #{params[:user]}."
          session[:user] = user.id
          session[:username] = user.username
          session[:logged] = true
          @user = user
        else
          flash[:notice] = "Código de validação inválido."
        end
      end
    else
      if @user==nil
        flash[:notice] = "Usuário #{params[:user]} não existe."
      else
        @bandas_count = Banda.count(:conditions=>{:user_id=>@user})
        @albuns_count = Album.count(:conditions=>{:user_id=>@user})
        @links_count = Link.count(:conditions=>{:user_id=>@user})
      end
    end

    respond_to do |format|
      if @user
        @user_albuns = Album.find_all_by_user_id(@user.id, :order=>"created_at DESC")
        format.html # show.html.erb
      else
        format.html {redirect_to(bandas_path)}
      end
    end
  end

  def novo
    @user = User.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        flash[:notice] = "Usuário #{@user.username} adicionado. Verifique seu email para concluir o cadastro."
        format.html { redirect_to(bandas_path)}
      else
        format.html { render :action => "novo" }
      end
    end
  end

  # atualiza user.info (bioline) por ajax
  def update_status
    new_info = params[:user][:info]
    my_id = session[:user].to_i
    # se estou editando minha info, update
    if my_id == params[:id].to_i && new_info
      user = User.update(my_id , {:info=>new_info})
      render :json => {:info=>user.reload.info}.to_json, :status=>200
    else
      render :nothing => true, :status=>500
    end

  end

end
