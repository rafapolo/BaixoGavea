class UsersController < ApplicationController
  def login
  end

  def authenticate
    user = User.find_by(username: params.dig(:user, :username), confirmado: true)

    if user.nil?
      flash.now[:notice] = "Usuário não existe."
      render :login, status: :unprocessable_entity and return
    end

    if user.authenticate(params.dig(:user, :password))
      session[:user_id] = user.id
      user.update(lastlogin_at: Time.current)
      flash[:notice] = "Bem-Vindo #{user.username}!"
      redirect_to(session.delete(:href) || root_path)
    else
      flash.now[:notice] = "Senha incorreta!"
      render :login, status: :unprocessable_entity
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "Tchau!"
    redirect_to(request.referer || root_path)
  end

  def show
    @user = User.find_by(username: params[:user], confirmado: true)

    if @user.nil?
      flash[:notice] = "Usuário #{params[:user]} não existe."
      redirect_to bandas_path and return
    end

    @bandas_count = Banda.where(user: @user).count
    @albuns_count = Album.where(user: @user).count
    @links_count = Link.where(user: @user).count
    @user_albuns = @user.albums.order(created_at: :desc)
  end

  def novo
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.confirmado = true

    if @user.save
      flash[:notice] = "Usuário #{@user.username} adicionado."
      redirect_to bandas_path
    else
      render :novo, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :info)
  end
end
