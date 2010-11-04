class User < ActiveRecord::Base
  named_scope :confirmado, :conditions => {:confirmado=> 1}
  named_scope :ultimos, :conditions => {:confirmado=>1}, :limit=>10

  has_many :links
  has_many :albuns
  has_many :bandas
  has_many :votos

  validates_uniqueness_of :username, :email, :message=>"já foi inserido"
  validates_uniqueness_of :normalizado, :message=>". Escolha outro username"
  validates_presence_of :username, :info, :email, :senha
  validates_format_of :email, :with=>/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
  validates_length_of :senha, :in=>6..15, :message=>"deve ter entre 6 e 15 caracteres"
  validates_length_of :username, :in=>4..15, :message=>"deve ter entre 4 e 15 caracteres"

  # retira espaços do username
  def before_validation
    self.username.gsub!(" ", "")
    self.username = self.username.urlize({:downcase=>false, :convert_spaces=>false})
    self.normalizado = self.username.downcase
  end

  # envia confirmação de cadastro
  def after_create
    Carteiro.deliver_confirme(self)
  end

  # gera hash para validação do usuário
  def gera_cod_valid
    user = self
    str_cod = user.email+user.username+user.senha+user.created_at.to_s
    Digest::MD5.hexdigest(str_cod)
  end

  # usuarios que adicionaram mais links
  def self.ativos
    find(
      :all,
      :limit=>10,
      :joins=>:links,
      :group=>"links.user_id",
      :select=>"*, COUNT(links.id) as links_count",
      :order => 'links_count DESC'
    )
  end

end
