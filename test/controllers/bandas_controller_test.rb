require "test_helper"

class BandasControllerTest < ActionDispatch::IntegrationTest
  test "root path lists bandas and shows counts" do
    user = User.create!(username: "polo", email: "polo@example.com", info: "info", password: "polopolo")
    Banda.create!(nome: "Raimundos", user: user)

    get root_path

    assert_response :success
    assert_select "h1", "BaixoGavea"
  end

  test "showing an existing banda" do
    user = User.create!(username: "polo", email: "polo@example.com", info: "info", password: "polopolo")
    banda = Banda.create!(nome: "Raimundos", user: user)

    get banda_path(banda.atalho)

    assert_response :success
    assert_select "h1", "Raimundos"
  end

  test "showing a missing banda redirects home with a notice" do
    get banda_path("nao-existe")

    assert_redirected_to root_path
    assert_equal "Não existe essa banda aqui. Adicione!", flash[:notice]
  end
end
