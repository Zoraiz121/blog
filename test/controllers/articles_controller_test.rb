require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      email: "author@example.com",
      password: "password123"
    )

    @article = Article.create!(
      title: "Test Article",
      body: "Test article body.",
      user: @user
    )
  end

  test "index page loads successfully" do
    get articles_url

    assert_response :success
  end

  test "signed-in user can open new article page" do
    sign_in @user

    get new_article_url

    assert_response :success
  end

  test "signed-in user can create an article" do
    sign_in @user

    assert_difference("Article.count", 1) do
      post articles_url, params: {
        article: {
          title: "Created Through Test",
          body: "This article was created by an automated test."
        }
      }
    end

    assert_redirected_to article_url(Article.last)
  end

  test "user cannot delete another user's article" do
  other_user = User.create!(
    email: "other@example.com",
    password: "password123"
  )

  sign_in other_user

  assert_no_difference("Article.count") do
    delete article_url(@article)
  end

  assert_response :redirect
end

test "visitor is redirected when opening new article page" do
  get new_article_url

  assert_redirected_to new_user_session_url
end
end
