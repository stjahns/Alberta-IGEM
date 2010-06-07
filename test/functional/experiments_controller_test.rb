require 'test_helper'

class ExperimentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:experiments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create experiment" do
    assert_difference('Experiment.count') do
      post :create, :experiment => { }
    end

    assert_redirected_to experiment_path(assigns(:experiment))
  end

  test "should show experiment" do
    get :show, :id => experiments(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => experiments(:one).to_param
    assert_response :success
  end

  test "should update experiment" do
    put :update, :id => experiments(:one).to_param, :experiment => { }
    assert_redirected_to experiment_path(assigns(:experiment))
  end

  test "should destroy experiment" do
    assert_difference('Experiment.count', -1) do
      delete :destroy, :id => experiments(:one).to_param
    end

    assert_redirected_to experiments_path
  end
end
