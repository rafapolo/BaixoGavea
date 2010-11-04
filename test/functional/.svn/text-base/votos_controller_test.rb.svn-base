require 'test_helper'

class VotosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:votos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create voto" do
    assert_difference('Voto.count') do
      post :create, :voto => { }
    end

    assert_redirected_to voto_path(assigns(:voto))
  end

  test "should show voto" do
    get :show, :id => votos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => votos(:one).to_param
    assert_response :success
  end

  test "should update voto" do
    put :update, :id => votos(:one).to_param, :voto => { }
    assert_redirected_to voto_path(assigns(:voto))
  end

  test "should destroy voto" do
    assert_difference('Voto.count', -1) do
      delete :destroy, :id => votos(:one).to_param
    end

    assert_redirected_to votos_path
  end
end
