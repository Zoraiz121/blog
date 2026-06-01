module Articles
  # Articles::CreateService
  #
  # Encapsulates all logic required to create a new article.
  # Called by ArticlesController#create and any other context
  # that needs to create articles (admin panel, API, imports).
  #
  # Usage:
  #   result = Articles::CreateService.call(current_user, article_params)
  #
  #   result.success? → true/false
  #   result.record   → the Article instance (persisted or not)
  #   result.errors   → array of error message strings on failure
  #
  # Responsibilities:
  #   - Build the article scoped to the user (sets user_id)
  #   - Assign permitted attributes
  #   - Set default status to draft
  #   - Calculate and store reading time
  #   - Persist the record
  #   - Return a ServiceResult

  class CreateService
    # .call is the single public interface.
    # Services are stateless — no instance is exposed outside this method.
    # Calling Articles::CreateService.call(...) is the entire API.
    def self.call(user, params)
      new(user, params).call
    end

    def initialize(user, params)
      @user   = user
      @params = params
    end

    def call
      build_article
      set_defaults
      calculate_reading_time

      if @article.save
        ServiceResult.ok(record: @article)
      else
        ServiceResult.fail(
          record: @article,
          errors: @article.errors.full_messages
        )
      end
    end

    private

    def build_article
      # Build scoped to the user — user_id is set automatically,
      # never passed through params (prevents mass assignment of owner).
      @article = @user.articles.build(@params)
    end

    def set_defaults
      # Status defaults to draft via the Visible concern's after_initialize
      # callback — nothing to set here explicitly.
      # This method exists as an extension point for future defaults
      # (e.g. setting locale, series, featured flag defaults).
    end

    def calculate_reading_time
      # Reading time is calculated from the body word count.
      # Industry standard: 238 words per minute (based on research
      # by Brysbaert et al., 2019 — average adult silent reading speed).
      # Minimum of 1 minute — "less than a minute" is confusing UX.
      #
      # Stored as an integer column (reading_time_minutes) on articles.
      # This column does not exist yet — it is added in P2 when the
      # full Readable concern is implemented. The calculation is here
      # now so the service is correct when the column arrives.
      return unless @article.body.present?
      return unless @article.respond_to?(:reading_time_minutes)

      word_count = @article.body.split.size
      @article.reading_time_minutes = [ (word_count / 238.0).ceil, 1 ].max
    end
  end
end
