require 'test_helper'

class StepsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:steps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create step" do
    assert_difference('Step.count') do
      post :create, :step => { }
    end

    assert_redirected_to step_path(assigns(:step))
  end

  test "should show step" do
    get :show, :id => steps(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => steps(:one).to_param
    assert_response :success
  end

  test "should update step" do
    put :update, :id => steps(:one).to_param, :step => { }
    assert_redirected_to step_path(assigns(:step))
  end

  test "should destroy step" do
    assert_difference('Step.count', -1) do
      delete :destroy, :id => steps(:one).to_param
    end

    assert_redirected_to steps_path
  end
end
