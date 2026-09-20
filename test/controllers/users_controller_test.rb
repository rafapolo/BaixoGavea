require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def create_confirmed_user
    User.create!(
      username: "polo",
      email: "polo@example.com",
      info: "info",
      password: "polopolo",
      confirmado: true
    )
  end

  test "renders the login form" do
    get login_path

    assert_response :success
    assert_select "form"
  end

  test "logs in with valid credentials" do
    create_confirmed_user

    post login_path, params: { user: { username: "polo", password: "polopolo" } }

    assert_redirected_to root_path
    assert_equal "Bem-Vindo polo!", flash[:notice]
  end

  test "rejects an incorrect password" do
    create_confirmed_user

    post login_path, params: { user: { username: "polo", password: "wrong" } }

    assert_response :unprocessable_entity
    assert_equal "Senha incorreta!", flash[:notice]
  end

  test "rejects an unknown username" do
    post login_path, params: { user: { username: "ghost", password: "whatever" } }

    assert_response :unprocessable_entity
    assert_equal "Usuário não existe.", flash[:notice]
  end

  test "signing up creates a confirmed user" do
    post usuarios_path, params: {
      user: {
        username: "novato",
        email: "novato@example.com",
        info: "oi",
        password: "senha123",
        password_confirmation: "senha123"
      }
    }

    assert_redirected_to bandas_path
    assert User.find_by(username: "novato").confirmado?
  end
end
