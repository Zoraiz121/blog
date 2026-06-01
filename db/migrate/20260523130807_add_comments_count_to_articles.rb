class AddCommentsCountToArticles < ActiveRecord::Migration[7.2]
  def change
    # Add the counter cache column with a default of 0.
    # NOT NULL with default 0 is the correct pattern for counter caches —
    # nil would break increment/decrement arithmetic.
    add_column :articles, :comments_count, :integer, null: false, default: 0

    # Backfill accurate counts for any existing comments.
    # Article.reset_counters is the Rails-provided way to recalculate
    # counter cache values from actual data rather than guessing.
    reversible do |dir|
      dir.up do
        Article.find_each do |article|
          Article.reset_counters(article.id, :comments)
        end
      end
    end
  end
end
