class Comment < ApplicationRecord
  include Visible

  # Associations
  # counter_cache: true automatically maintains articles.comments_count.
  belongs_to :article, counter_cache: true
  belongs_to :user

  # Validations
  validates :body, presence: true
end
