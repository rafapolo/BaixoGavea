# polo 22/Set/09

class Tuitero

  def self.diz(msg)
    return if ENV['RAILS_ENV'] == 'development' # só diz em produção
    httpauth = Twitter::HTTPAuth.new('baixo_gavea', 'senha:twitter')
    client = Twitter::Base.new(httpauth)
    client.update(msg)
  end

end
