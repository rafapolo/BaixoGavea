require "test_helper"

class BandaTest < ActiveSupport::TestCase
  def build_user
    User.create!(username: "polo", email: "polo@example.com", info: "info", password: "polopolo")
  end

  test "generates an atalho (slug) from the nome" do
    banda = Banda.new(nome: "Raimundos", user: build_user)
    assert banda.save
    assert_equal "raimundos", banda.atalho
  end

  test "requires a unique nome" do
    user = build_user
    Banda.create!(nome: "Raimundos", user: user)
    duplicate = Banda.new(nome: "Raimundos", user: user)

    assert_not duplicate.save
    assert_includes duplicate.errors[:nome], "has already been taken"
  end

  test "requires a nome between 2 and 55 characters" do
    banda = Banda.new(nome: "R", user: build_user)
    assert_not banda.save
  end

  test "find_by_letra filters bandas by their first letter" do
    user = build_user
    Banda.create!(nome: "Raimundos", user: user)
    Banda.create!(nome: "Skank", user: user)

    assert_equal ["Raimundos"], Banda.find_by_letra("r").pluck(:nome)
  end
end
