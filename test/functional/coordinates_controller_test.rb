require 'test_helper'

class CoordinatesControllerTest < ActionController::TestCase
  setup do
    @coordinate = coordinates(:one)
    sign_in users(:one)
    prepare_nominatim_stub
  end

  test "should get index" do
    get :index, :track_id => @coordinate.track_id
    assert_response :success
    assert_not_nil assigns(:coordinates)
  end

  test "should get new" do
    get :new, :track_id => @coordinate.track_id
    assert_response :success
  end

  test "should create coordinate" do
    assert_difference('Coordinate.count') do
      post :create, :track_id => @coordinate.track_id, coordinate: { latitude: 1.1, longitude: 2.2 }
    end

    assert_redirected_to track_coordinate_path(assigns(:track), assigns(:coordinate))
  end

  test "should show coordinate" do
    get :show, :track_id => @coordinate.track_id, id: @coordinate
    assert_response :success
  end

  test "should get edit" do
    get :edit, :track_id => @coordinate.track_id, id: @coordinate
    assert_response :success
  end

  test "should update coordinate" do
    put :update, :track_id => @coordinate.track_id, id: @coordinate, coordinate: {  }
    assert_redirected_to track_coordinate_path(assigns(:track), assigns(:coordinate))
  end

  test "should destroy coordinate" do
    assert_difference('Coordinate.count', -1) do
      delete :destroy, :track_id => @coordinate.track_id, id: @coordinate
    end

    assert_redirected_to track_coordinates_path
  end
end
