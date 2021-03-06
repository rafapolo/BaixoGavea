# Mark Swardstrom
# http://www.swards.net/2009/04/google-image-search-in-rails-using.html

class GoogleImage

  require 'json'

  attr_accessor :thumbnail, :original, :name, :position

  def initialize(params)
    super()
    self.name = params[:name]
    self.thumbnail = params[:thumbnail]
    self.original = params[:original]
    self.position = params[:position]
  end

  def self.find (album, position = 0)
    banda_nome = CGI.escape('"'+album.banda.nome+'"')
    album_nome = CGI.escape('"'+album.nome+'"')
    query = "#{banda_nome}+#{album_nome}"
    #return [] if (keyword.nil? || keyword.strip.blank?)
    url = "http://ajax.googleapis.com/ajax/services/search/images?hl=pt-BR&rsz=large&start=#{position}&v=1.0&q=#{query}"
    begin
      results = JSON.parse(open(url).read)
      image_array = results['responseData']['results']
      google_image = nil
      if image_array && image_array[0]
        image = image_array[0]
        google_image = self.new(:thumbnail => image['tbUrl'], :original => image['unescapedUrl'], :position => position, :name => query.titleize)
      end
      google_image = google_image ? google_image.thumbnail : "no-image.jpg"
    rescue
      return "no-image.jpg"
    end
    google_image
  end

end