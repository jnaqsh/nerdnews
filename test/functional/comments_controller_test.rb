require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @comment = comments(:one)
    @story = stories(:one)
  end

  test "should get index" do
    get :index, :story_id => @story.id
    assert_response :success
    assert_not_nil assigns(:comments)
  end

  test "should get new" do
    get :new, :story_id => @story.id
    assert_response :success
  end

  test "should create comment" do
    assert_difference('Comment.count') do
      post :create, :story_id => @story.id, comment: { content: @comment.content, name: @comment.name, email: @comment.email }
    end

    assert_redirected_to story_path(@story.id)
  end

  test "should show comment" do
    get :show, :story_id => @story.id, id: @comment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @comment, :story_id => @story.id
    assert_response :success
  end

  test "should update comment" do
    put :update, :story_id => @story.id, id: @comment, comment: { content: @comment.content, name: @comment.name }
    assert_redirected_to story_path
  end

  test "should destroy comment" do
    assert_difference('Comment.count', -1) do
      delete :destroy, :story_id => @story.id, id: @comment
    end

    assert_redirected_to story_path
  end
end
