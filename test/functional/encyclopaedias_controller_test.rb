require 'test_helper'

class EncyclopaediasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:encyclopaedias)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create encyclopaedia" do
    assert_difference('Encyclopaedia.count') do
      post :create, :encyclopaedia => { }
    end

    assert_redirected_to encyclopaedia_path(assigns(:encyclopaedia))
  end

  test "should show encyclopaedia" do
    get :show, :id => encyclopaedias(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => encyclopaedias(:one).to_param
    assert_response :success
  end

  test "should update encyclopaedia" do
    put :update, :id => encyclopaedias(:one).to_param, :encyclopaedia => { }
    assert_redirected_to encyclopaedia_path(assigns(:encyclopaedia))
  end

  test "should destroy encyclopaedia" do
    assert_difference('Encyclopaedia.count', -1) do
      delete :destroy, :id => encyclopaedias(:one).to_param
    end

    assert_redirected_to encyclopaedias_path
  end
end
