require 'test_helper'

class TracksControllerTest < ActionController::TestCase
  setup do
    @track = tracks(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:my_tracks)
    assert_not_nil assigns(:friends_tracks)
  end

  test "should get new" do
    get :new, :format => "json"
    assert_response :success
  end

  test "should create track" do
    assert_difference('Track.count') do
      post :create, :format => "json", track: { name: "test" }
    end

    assert_response :success
  end

  test "should show track" do
    get :show, id: @track
    assert_response :success
  end

  test "should get edit" do
    get :edit, :format => "js", id: @track
    assert_response :success
  end

  test "should update track" do
    put :update, id: @track, track: {  }
    assert_redirected_to track_path(assigns(:track))
  end

  test "should destroy track" do
    assert_difference('Track.count', -1) do
      delete :destroy, id: @track
    end

    assert_redirected_to tracks_path
  end
end
