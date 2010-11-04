class Album < ActiveRecord::Base
  belongs_to :user
  belongs_to :banda
  has_many :links, :dependent => :destroy , :order=>"is_torrent DESC"

  validates_presence_of :nome, :ano, :banda, :user
  validates_length_of :nome, :in=>2..55, :message=>"deve ter entre 2 e 55 caracteres"
  before_create :um_nome_album_por_banda_create
  before_update :um_nome_album_por_banda_update

  def before_save
    self.nome.strip!
    self.atalho = nome.urlize({:downcase=>true, :convert_spaces=>true})
    self.image_url = GoogleImage.find(self) if !self.image_url
  end

  def um_nome_album_por_banda_update
    atalho = self.nome.urlize({:downcase=>true, :convert_spaces=>true})
    igual = Album.find(:all, :conditions => ['banda_id = ? AND atalho = ?', self.banda.id, atalho])    
    if igual.size > 0 && igual.first.id  != self.id
      errors.add(:album, "já inserido.")
    end
    errors.empty?
  end

  def um_nome_album_por_banda_create
    if Album.count(:conditions => ['banda_id = ? AND atalho = ?', self.banda.id, self.atalho]) > 0
      errors.add(:album, "já inserido.")
    end
    errors.empty?
  end

  # últimos 10 albuns que tiveram links adicionados
  def self.ultimos
    find(
      :all,
      :limit=>10,
      :joins=>:links,
      :group=>"albuns.id",
      :select=>"*",
      :order => 'links.created_at DESC'
    )
  end

end
