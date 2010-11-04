class Voto < ActiveRecord::Base
  belongs_to :link
  belongs_to :user

  validates_presence_of :link, :comentario, :user, :ponto

  def after_create
    if self.comentario != "adicionei esse novo liame" && self.ponto==-1
    Carteiro.deliver_negativo(self)
    end
  end

end
