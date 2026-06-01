class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    # @user is the currently signed-in user viewing their own profile.
    # Public author profile pages (viewing another user's profile) are
    # a P2 feature — they require a public route scoped to username/slug.
    @user = current_user
    @articles = current_user.articles
                            .order(created_at: :desc)
                            .limit(10)
  end
end
