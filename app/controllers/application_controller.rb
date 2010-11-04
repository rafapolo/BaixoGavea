class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "geral", :except => [:stats, :sitemap]
  
  before_filter :login, :only=>[:new, :upload]
  
  def login    
    return true if session[:user] && session[:logged] && session[:username]
    session[:href] = request.referer
    flash[:notice] = "Você precisa se autenticar."
    redirect_to("/login")
  end

  filter_parameter_logging :senha
end