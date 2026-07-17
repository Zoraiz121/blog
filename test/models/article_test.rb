require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "article is valid with required information" do
    user = User.create!(
      email: "writer@example.com",
      password: "password123"
    )

    article = Article.new(
      title: "My First Article",
      body: "This is the article body.",
      user: user
    )

    assert article.valid?
  end

  test "article is invalid without a title" do
    user = User.create!(
      email: "writer2@example.com",
      password: "password123"
    )

    article = Article.new(
      title: nil,
      body: "This article has no title.",
      user: user
    )

    assert_not article.valid?
    assert article.errors[:title].any?
  end
end
