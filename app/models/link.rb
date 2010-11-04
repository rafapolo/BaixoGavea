class Link < ActiveRecord::Base
  belongs_to :album
  belongs_to :user  
  belongs_to :tracker
  belongs_to :torrent, :dependent => :destroy
  has_many :votos, :dependent => :destroy

  validates_uniqueness_of :url, :message=>"já foi cadastrada"
  validates_presence_of :url, :album, :user
  validates_format_of :url, :message=>"deve ter o formato de uma URL", :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
  after_validation_on_create :pegadominio

  # Diz no Twitter a criação do Links
  def after_create
    Voto.create(:link_id=>self.id, :user_id=>self.user.id, :ponto=>1, :comentario=>"Novo liame adicionado.")
    Tuitero.diz("#{self.user.username} adicionou um #liame para #{self.album.banda.nome} - #{self.album.nome} em http://baixogavea.com/#{self.album.banda.atalho}/#{self.album.atalho}")
  end

  def before_validation
    unless self.is_torrent
      # mas camarada adiciona .torrent como url de link
      if self.url.ends_with?(".torrent")
        return false
      else
        self.url.strip!
      end
    else
      self.url = "http://baixogavea.com/torrent/#{self.torrent.fixhash}"
    end
  end

  private
  def pegadominio
    return true if self.is_torrent
    # só http-url
    if self.errors.count>0 || !self.url
      return false
    end
    parsed_url = Domainatrix.parse(self.url)
    host = "#{parsed_url.domain}.#{parsed_url.public_suffix}"
    tracker = Tracker.find_by_url(host)
    if !tracker
      server = Tracker.create(:nome=>host, :url=>host)
      self.tracker_id = server.id
    else
      self.tracker_id = tracker.id
    end
  end
end
