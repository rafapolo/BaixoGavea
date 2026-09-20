require "test_helper"

class AlbumTest < ActiveSupport::TestCase
  def build_banda
    user = User.create!(username: "polo", email: "polo@example.com", info: "info", password: "polopolo")
    Banda.create!(nome: "Raimundos", user: user)
  end

  test "generates an atalho (slug) from the nome" do
    banda = build_banda
    album = Album.new(nome: "Lapadas do Povo", ano: 1996, banda: banda, user: banda.user)

    assert album.save
    assert_equal "lapadas-do-povo", album.atalho
  end

  test "requires a unique nome scoped to the banda" do
    banda = build_banda
    Album.create!(nome: "Lapadas do Povo", ano: 1996, banda: banda, user: banda.user)
    duplicate = Album.new(nome: "Lapadas do Povo", ano: 1997, banda: banda, user: banda.user)

    assert_not duplicate.save
  end

  test "requires an ano" do
    banda = build_banda
    album = Album.new(nome: "Lapadas do Povo", banda: banda, user: banda.user)

    assert_not album.save
    assert_includes album.errors[:ano], "can't be blank"
  end
end
