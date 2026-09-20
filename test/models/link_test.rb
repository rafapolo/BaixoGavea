require "test_helper"

class LinkTest < ActiveSupport::TestCase
  def build_album
    user = User.create!(username: "polo", email: "polo@example.com", info: "info", password: "polopolo")
    banda = Banda.create!(nome: "Raimundos", user: user)
    Album.create!(nome: "Lapadas do Povo", ano: 1996, banda: banda, user: user)
  end

  test "requires a well formed url" do
    album = build_album
    link = Link.new(url: "not a url", album: album, user: album.user)

    assert_not link.save
  end

  test "requires a unique url" do
    album = build_album
    Link.create!(url: "http://example.com/one.mp3", album: album, user: album.user)
    duplicate = Link.new(url: "http://example.com/one.mp3", album: album, user: album.user)

    assert_not duplicate.save
  end

  test "creating a link automatically adds an initial voto" do
    album = build_album
    link = Link.create!(url: "http://example.com/two.mp3", album: album, user: album.user)

    assert_equal 1, link.votos.count
    assert_equal "Novo liame adicionado.", link.votos.first.comentario
  end
end
