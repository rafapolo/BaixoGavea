# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def highlight(termo, txt)
    txt.gsub(Regexp.new("(#{termo})", Regexp::IGNORECASE) , '<b class=highligth>\1</b>')
  end
  alias_method(:hl, :highlight)

  def image_voto(voto)
    voto > 0 ? image_tag("bom.png") : image_tag("ruim.png")
  end

  def to_size(bytes)
    kb = (bytes / 1024.0)

    if kb > 1024
      mb = kb / 1024
      if mb > 1024
        gb = mb/1024
        return sprintf('%.2f', gb) + " GB"
      else
        return sprintf('%.2f', mb) + " MB"
      end
    else
      return sprintf('%.2f', kb) + " KB"
    end
  end
  
    def time_ago(original, options = {})
      start_date = options.delete(:start_date) || Time.now
      round = options.delete(:round) || 7
      max_seconds = options.delete(:max_seconds) || 32556926

      chunks = [
        [60 * 60 * 24 * 365 , "ano"],
        [60 * 60 * 24 * 30 , "mês"],
        [60 * 60 * 24 * 7, "semana"],
        [60 * 60 * 24 , "dia"],
        [60 * 60 , "hora"],
        [60 , "minuto"],
        [1 , "segundo"]
      ]

      since = start_date.to_i - original.to_i
      time = []

      if since < max_seconds
        # Loop trough all the chunks
        totaltime = 0

        for chunk in chunks[0..round-2]
          seconds    = chunk[0]
          name       = chunk[1]
          count = ((since - totaltime) / seconds).floor
          time << pluralize(count, name) unless count == 0
          totaltime += count * seconds
        end

        if time.empty?
          "segundos"
        else
          time.join(" ")
        end

      end
    end

    def link_user_path(user)
      link_to user.username, user_path(user)
    end

    def new_album_link(album)
      "#{album.banda.atalho}/#{album.atalho}/novo_link"
    end

    def banda_path(banda)
      "/"+banda.atalho
    end

    def user_path(user)
      "/usuario/#{user.username}"
    end

    def editar_album_path(album)
      "/album/editar/#{album.id}"
    end

    def excluir_album_path(album)
      "/album/excluir/#{album.id}"
    end

    def destroy_album_path(album)
      "/album/destroy/#{album.id}"
    end

    def albuns_path
      "/albuns"
    end

    def pontos_link(link)
      ponto = Voto.sum('ponto', :conditions =>["link_id = ?", link.id])
      ponto >= 0 ? "<font color='green'>+#{ponto}</font>" : "<font color='red'>#{ponto}</font>"
    end

    def album_image(album)
      image_tag(album.image_url, :class=>"capa_album")
    end

    def album_name(album)
      "#{album.banda.nome} - #{album.nome} (#{album.ano})"
    end

    def new_link_path(album)
      "/#{album.banda.atalho}/#{album.atalho}/novo_link"
    end

    def new_album_path(banda)
      "/#{banda.atalho}/novo_album"
    end

    def album_path(album)
      "/#{album.banda.atalho}/#{album.atalho}"
    end

    def user_path(user)
      "/usuario/#{user.username}"
    end

    def href_menu(letra)
      txt = letra == "#" ? '9' : letra
      "<a href='/bandas/#{txt.downcase}'>#{letra}</a>"
    end

    def edit_in_place(resource, field, options={})
      # Get record to be edited. If resource is an array, pull it out.
      record = resource.is_a?(Array) ? resource.last : resource

      options[:id] ||= "#{dom_id(record)}_#{field}"
      options[:tag] ||= :span
      options[:url] ||= url_for(resource)
      options[:rel] ||= options.delete(:url)
      options.delete(:url) # Just in case it wasn't cleared already

      classes = options[:class].split(' ') rescue []
      classes << 'editable' if classes.empty?
      options[:class] = classes.uniq.join(' ')

      content_tag(options.delete(:tag), record.send(field), options)
    end

  end
