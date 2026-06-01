module Articles
  # Articles::UpdateService
  #
  # Encapsulates all logic required to update an existing article.
  # Ownership is verified by the controller before this service is called
  # (via set_own_article) — this service trusts that the article belongs
  # to an authorized user and focuses purely on update logic.
  #
  # Usage:
  #   result = Articles::UpdateService.call(@article, article_params)
  #
  #   result.success? → true/false
  #   result.record   → the Article instance (updated or not)
  #   result.errors   → array of error message strings on failure
  #
  # Responsibilities:
  #   - Assign updated attributes
  #   - Recalculate reading time if body changed
  #   - Persist the record
  #   - Return a ServiceResult

  class UpdateService
    def self.call(article, params)
      new(article, params).call
    end

    def initialize(article, params)
      @article = article
      @params  = params
    end

    def call
      assign_attributes
      recalculate_reading_time_if_needed

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

    def assign_attributes
      @article.assign_attributes(@params)
    end

    def recalculate_reading_time_if_needed
      # Only recalculate if the body is being changed in this update.
      # Avoids touching reading_time_minutes when only the title or
      # cover image changes — no unnecessary computation.
      return unless @article.body_changed?
      return unless @article.respond_to?(:reading_time_minutes)
      return unless @article.body.present?

      word_count = @article.body.split.size
      @article.reading_time_minutes = [ (word_count / 238.0).ceil, 1 ].max
    end
  end
end
