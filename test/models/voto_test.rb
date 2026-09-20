require "test_helper"

class VotoTest < ActiveSupport::TestCase
  def build_link
    user = User.create!(username: "polo", email: "polo@example.com", info: "info", password: "polopolo")
    banda = Banda.create!(nome: "Raimundos", user: user)
    album = Album.create!(nome: "Lapadas do Povo", ano: 1996, banda: banda, user: user)
    Link.create!(url: "http://example.com/one.mp3", album: album, user: user)
  end

  test "requires a comentario" do
    link = build_link
    voto = Voto.new(link: link, user: link.user, ponto: 1)

    assert_not voto.save
  end

  test "only accepts a ponto of 1 or -1" do
    link = build_link
    voto = Voto.new(link: link, user: link.user, ponto: 5, comentario: "ok")

    assert_not voto.save
  end

  test "accepts a valid vote" do
    link = build_link
    voto = Voto.new(link: link, user: link.user, ponto: -1, comentario: "quebrado")

    assert voto.save
  end
end
