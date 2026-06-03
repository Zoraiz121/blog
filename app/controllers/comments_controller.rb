class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article
  before_action :set_comment, only: [ :destroy ]
  before_action :set_own_comment_or_article_owner!, only: [ :destroy ]

  def create
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to article_path(@article), notice: "Comment added successfully."
    else
      redirect_to article_path(@article), alert: "Could not add comment."
    end
  end

before_action :authenticate_user!, only: [ :destroy ]

def destroy
  @article = Article.friendly.find(params[:article_id])
  @comment = @article.comments.find(params[:id])

  if @comment.user == current_user
    @comment.destroy
    redirect_to @article, notice: "Comment deleted"
  else
    redirect_to @article, alert: "Not authorized"
  end
end

  private

  def set_article
    # Scoped find — the article must exist regardless of ownership.
    # Comments belong to articles, not directly to users at the route level.
    @article = Article.friendly.find(params[:article_id])
  end

  def set_comment
    # Scoped to the article — prevents arbitrary comment ID injection.
    # A comment with this ID must belong to this article or RecordNotFound.
    @comment = @article.comments.find(params[:id])
  end

  def set_own_comment_or_article_owner!
    # Comments have two legitimate deletion authorities:
    #   1. The person who wrote the comment (comment owner)
    #   2. The person who wrote the article (article owner — moderating their space)
    #
    # own?(@comment) checks comment.user_id == current_user.id
    # own?(@article) checks article.user_id == current_user.id
    #
    # Both use the shared own? helper from the Authorizable concern.
    # If neither is true, require_ownership! redirects with an alert.
    #
    # Note: own?(@article) is checked second — article owners can delete
    # any comment on their article, not just their own comments.
    unless own?(@comment) || own?(@article)
      require_ownership!(@comment)
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
