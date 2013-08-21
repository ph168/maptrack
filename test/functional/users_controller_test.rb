require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @user2 = users(:two)
    @friendship = friendships(:one)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_equal @user, assigns(:user)
  end

  test "should show user" do
    get :show, :format => "js", name: @user2.name
    assert_response :success
  end

  test "should get edit" do
    get :edit, :format => "js"
    assert_response :success
    assert_equal @user, assigns(:user)
  end

  test "should update user" do
    put :update, user: {  }
    assert_response :success
  end

  test "should request friendship" do
    assert_difference('Friendship.count') do
      post :request_friendship, friendship: { consumer_id: @user2.id }
    end

    assert_redirected_to action: "index", notice: "Friendship was successfully requested."
  end

  test "should confirm friendship" do
    post :confirm_friendship, id: @friendship.id
    assert_redirected_to action: "index", notice: "Friendship was successfully confirmed."
  end
end
