require "test_helper"

class CommentTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      email: "commenter@example.com",
      password: "password123"
    )

    @article = Article.create!(
      title: "Article With Comments",
      body: "This article is used for comment testing.",
      user: @user
    )
  end

  test "comment belongs to an article" do
    comment = Comment.create!(
      body: "This is a test comment.",
      article: @article,
      user: @user
    )

    assert_equal @article, comment.article
  end

  test "deleting article removes its comments" do
    Comment.create!(
      body: "This comment should be removed.",
      article: @article,
      user: @user
    )

    assert_difference("Comment.count", -1) do
      @article.destroy
    end
  end
end
