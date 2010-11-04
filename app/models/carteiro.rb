class Carteiro < ActionMailer::Base

  def confirme(user)
    return if ENV['RAILS_ENV'] == 'development' # só envia em produção
    @subject = "[BaixoGavea.com] Confirme seu cadastro."
    @recipients = user.email
    @from = 'robo@baixogavea.com'
	  @body["username"] = user.username
	  @body["validation"] = user.gera_cod_valid
    @sent_on = Time.now
  end

  def negativo(voto)
    return if ENV['RAILS_ENV'] == 'development' # só envia em produção
    @subject = "[BaixoGavea.com] Link quebrado?"
    @recipients = voto.link.user.email #owner
    @from = 'robo@baixogavea.com'
	  @body["own_username"] = voto.link.user.username
	  @body["voto_username"] = voto.user.username
	  @body["url"] = voto.link.url
    @body["comentario"] = voto.comentario
    @body["album"] = voto.link.album.nome
    @sent_on = Time.now
  end

end
