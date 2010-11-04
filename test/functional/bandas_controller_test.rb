require 'test_helper'

class BandasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bandas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create banda" do
    assert_difference('Banda.count') do
      post :create, :banda => { }
    end

    assert_redirected_to banda_path(assigns(:banda))
  end

  test "should show banda" do
    get :show, :id => bandas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => bandas(:one).to_param
    assert_response :success
  end

  test "should update banda" do
    put :update, :id => bandas(:one).to_param, :banda => { }
    assert_redirected_to banda_path(assigns(:banda))
  end

  test "should destroy banda" do
    assert_difference('Banda.count', -1) do
      delete :destroy, :id => bandas(:one).to_param
    end

    assert_redirected_to bandas_path
  end
end
