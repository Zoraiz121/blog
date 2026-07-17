class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :set_article, only: [ :show, :edit, :update, :destroy ]


def index
  articles = Article
               .includes(:cover_image_attachment, :image_attachment)
               .order(created_at: :desc)

  if params[:query].present?
    search_term = "%#{ActiveRecord::Base.sanitize_sql_like(params[:query])}%"

    articles = articles.where(
      "title LIKE :term OR body LIKE :term",
      term: search_term
    )
  end

  @pagy, @articles = pagy(articles)
end

  def show
    @comments = @article.comments.includes(:user).order(created_at: :desc)
    @comment = Comment.new
  end

  def new
    @article = Article.new
  end

def create
  @article = current_user.articles.build(article_params)

  if @article.save
    redirect_to @article, notice: "Article created successfully."
  else
    render :new, status: :unprocessable_entity
  end
end

  def edit
    unless @article.user == current_user
      redirect_to @article, alert: "Not authorized."
    end
  end

def update
    if @article.update(article_params)
      redirect_to @article, notice: "Article updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless @article.user == current_user
      redirect_to @article, alert: "Not authorized."
      return
    end

    @article.destroy
    redirect_to articles_path, notice: "Article deleted successfully."
  end

  private

def set_article
  @article = Article.friendly.find(params[:id])
end


def article_params
  params.require(:article).permit(:title, :body, :status, :category, :cover_image, :image)
end
end
