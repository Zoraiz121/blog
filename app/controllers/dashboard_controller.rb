class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    articles = current_user.articles

    @total_articles = articles.count
    @published_articles = articles.published.count
    @draft_articles = articles.draft.count
    @archived_articles = articles.archived.count

    @total_comments = Comment.where(
      article_id: articles.select(:id)
    ).count

    @articles = articles
                  .includes(:cover_image_attachment)
                  .order(updated_at: :desc)
                  .limit(10)
  end
end
