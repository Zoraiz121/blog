class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article
  before_action :set_comment, only: [ :edit, :update, :destroy ]
  before_action :authorize_comment_owner!, only: [ :edit, :update, :destroy ]

  def create
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @article, notice: "Comment added successfully."
    else
      redirect_to @article, alert: "Comment cannot be blank."
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to @article, notice: "Comment updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to @article, notice: "Comment deleted successfully."
  end

  private

  def set_article
    @article = Article.friendly.find(params[:article_id])
  end

  def set_comment
    @comment = @article.comments.find(params[:id])
  end

  def authorize_comment_owner!
    return if @comment.user_id == current_user.id

    redirect_to @article, alert: "Not authorized."
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
