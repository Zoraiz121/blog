class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :set_article,        only: [ :show ]
  before_action :set_own_article,    only: [ :edit, :update, :destroy ]

  def index
    @pagy, @articles = pagy(
      Article.includes(:user).order(created_at: :desc),
      limit: 12
    )
  end

  def show
  end

  def new
    @article = current_user.articles.build
  end

  def create
    result = Articles::CreateService.call(current_user, article_params)

    if result.success?
      redirect_to result.record, notice: "Article created successfully."
    else
      @article = result.record
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    result = Articles::UpdateService.call(@article, article_params)

    if result.success?
      redirect_to result.record, notice: "Article updated successfully."
    else
      @article = result.record
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: "Article deleted.", status: :see_other
  end

  private

  def set_article
    # Public read — finds any article regardless of owner.
    # Any visitor can view a published article.
    @article = Article.friendly.find(params[:id])
  end

  def set_own_article
    # Primary authorization layer — query scoped to current user.
    # Raises RecordNotFound (404) if the article exists but belongs
    # to a different user. Ownership cannot be bypassed here.
    @article = current_user.articles.friendly.find(params[:id])
  end
end
