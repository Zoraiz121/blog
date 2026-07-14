module Visible
  extend ActiveSupport::Concern

  # All valid status values defined in one place.
  # Reference these constants everywhere instead of raw strings:
  #   Article::STATUSES        → ["draft", "published", "archived"]
  #   Article::DEFAULT_STATUS  → "draft"
  #
  # This means a typo like Article::STTUASES fails loudly at boot,
  # whereas "pubilshed" fails silently at runtime with no match.
  STATUSES = %w[draft published archived].freeze
  DEFAULT_STATUS = "draft"

  included do
    # Enforce valid status values at the model layer.
    # Any attempt to save an invalid status raises a validation error
    # with a clear message rather than silently writing garbage to the DB.
    validates :status,
              presence: true,
              inclusion: {
                in: STATUSES,
                message: "must be one of: #{STATUSES.join(', ')}"
              }

    # Set default status on initialization so new records are always
    # in a known state without the caller needing to specify it.
    after_initialize :set_default_status, if: :new_record?

    # Named scopes — query published/draft/archived records without
    # writing WHERE clauses or magic strings anywhere else.
    #
    # Usage:
    #   Article.published          → all published articles
    #   Article.draft              → all drafts
    #   Article.archived           → all archived
    #   Article.published.order(:created_at)  → chainable
    scope :published, -> { where(status: "published") }
    scope :draft,     -> { where(status: "draft") }
    scope :archived,  -> { where(status: "archived") }
  end

  # ---------------------------------------------------------------------------
  # Predicate methods
  # Use these in views and controllers instead of comparing strings directly:
  #   article.published?   not   article.status == "published"
  # ---------------------------------------------------------------------------

  def published?
    status == "published"
  end

def draft?
    status == "draft"
  end

  def archived?
    status == "archived"
  end
  # ---------------------------------------------------------------------------
  # Transition methods
  # Encapsulate status changes so the caller does not manage the string.
  # Each method updates status and persists immediately.
  # Returns true on success, false on validation failure.
  #
  # Usage:
  #   article.publish!    → sets status "published", saves, returns true/false
  #   article.archive!    → sets status "archived", saves, returns true/false
  #   article.unpublish!  → sets status back to "draft", saves, returns true/false
  # ---------------------------------------------------------------------------

  def publish!
    update(status: "published")
  end

  def archive!
    update(status: "archived")
  end

  def unpublish!
    update(status: "draft")
  end

  # ---------------------------------------------------------------------------
  # Display helper
  # Returns a human-friendly label for the current status.
  # Useful in admin tables and article management UIs.
  # ---------------------------------------------------------------------------

  def status_label
    status.humanize
  end

  private

  def set_default_status
    self.status ||= DEFAULT_STATUS
  end
end
