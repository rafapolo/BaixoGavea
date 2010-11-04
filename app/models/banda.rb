class Banda < ActiveRecord::Base
  belongs_to :user
  has_many :albuns, :dependent => :destroy  

  validates_uniqueness_of :atalho, :nome, :message=>"já foi inserido"
  validates_presence_of :nome, :user
  validates_length_of :nome, :in=>2..55, :message=>"deve ter entre 2 e 55 caracteres"
  before_create :urlize

  def self.find_by_letra(letter)
    if letter=="9"
      find(:all, :conditions => ['nome LIKE ? OR nome LIKE ? OR nome LIKE ? OR nome LIKE ? OR nome LIKE ? OR nome LIKE ? OR nome LIKE ? OR nome LIKE ? OR nome LIKE ? OR nome LIKE ?', "#{0}%", "#{1}%", "#{2}%", "#{3}%", "#{4}%", "#{5}%", "#{6}%", "#{7}%", "#{8}%", "#{9}%"], :order => 'nome ASC')
    else
      find(:all, :conditions => ['nome LIKE ?', "#{letter}%"], :order => 'nome ASC')
    end
  end

  private
  def urlize
    self.nome.strip!
    self.atalho = nome.urlize({:downcase=>true, :convert_spaces=>true})
  end

    # algumas
    def self.algumas
        Banda.find :all, :offset => (Banda.count * rand ).to_i ,:limit=>10
  end
end