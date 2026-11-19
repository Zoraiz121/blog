class Article < ApplicationRecord
  include Visible
  extend FriendlyId

  # FriendlyId — SEO-friendly slugs from title
  friendly_id :title, use: :slugged

  # Associations
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_one_attached :cover_image
  has_one_attached :image

  #before_save :test_callback

  # Validations
  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
  validates :title,
          presence: { message: "can't be blank" },
          length: {
            minimum: 5,
            maximum: 100,
            message: "must be between 5 and 100 characters"
          }

validates :body,
          presence: { message: "can't be blank" },
          length: {
            minimum: 10,
            maximum: 5000,
            message: "must be between 10 and 5000 characters"
          }

validate :title_must_not_contain_restricted_words

private

def title_must_not_contain_restricted_words
  restricted_words = %w[test admin]

  if restricted_words.any? { |word| title.to_s.downcase.include?(word) }
    errors.add(:title, "contains a restricted word")
  end
end




  # scope :draft_articles -> {where(status: "draft")}

  # Article.draft_articles

  # Regenerate slug when title changes
  def should_generate_new_friendly_id?
    title_changed? || super
  end

  # ==> Active Storage image variants
  #
  # Pre-define variants so views call a named variant rather than
  # specifying resize dimensions inline. This means:
  #   1. Dimensions are defined in one place — change here, updates everywhere
  #   2. Views stay clean: cover_image.variant(:thumb) not
  #      cover_image.variant(resize_to_fill: [400, 250])
  #   3. Variants are processed lazily on first request then cached by
  #      Active Storage — no upfront processing cost on upload
  #
  # Usage in views:
  #   image_tag @article.cover_image.variant(:thumb)   ← article index cards
  #   image_tag @article.cover_image.variant(:hero)    ← article show page
  #   image_tag @article.cover_image.variant(:og)      ← Open Graph meta tag

  COVER_IMAGE_VARIANTS = {
    # Small thumbnail for article listing cards
    # Cropped to exact dimensions — consistent card heights
    thumb: { resize_to_fill: [ 600, 340 ] },

    # Full-width hero image for article show page
    # Fills the article header without cropping the subject
    hero:  { resize_to_limit: [ 1200, 630 ] },

    # Open Graph / Twitter Card sharing image
    # Exactly the recommended OG image dimensions
    og:    { resize_to_fill: [ 1200, 630 ] }
  }.freeze

  def cover_image_variant(variant_name)
    return unless cover_image.attached?

    dimensions = COVER_IMAGE_VARIANTS.fetch(variant_name) do
      raise ArgumentError, "Unknown variant: #{variant_name}. " \
                           "Valid variants: #{COVER_IMAGE_VARIANTS.keys.join(', ')}"
    end

    cover_image.variant(dimensions)
  end

 #private
  #def test_callback
    # do something

   # binding.pry
  #end
end
