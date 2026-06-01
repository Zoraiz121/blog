class AddSlugToArticles < ActiveRecord::Migration[7.2]
  def change
    # slug column — stores the URL-safe version of the article title.
    # Unique index enforces no two articles share the same URL.
    # Allow null initially so we can backfill existing rows before
    # tightening the constraint.
    add_column :articles, :slug, :string
    add_index :articles, :slug, unique: true

    # Backfill slugs for any articles that already exist.
    # FriendlyId is not available inside migrations reliably,
    # so we generate slugs manually using pure SQL-safe Ruby.
    # This matches FriendlyId's own parameterization logic.
    reversible do |dir|
      dir.up do
        execute("SELECT id, title FROM articles").each do |row|
          raw_slug = row["title"].to_s
                       .downcase
                       .strip
                       .gsub(/[^a-z0-9\s-]/, "")
                       .gsub(/\s+/, "-")
                       .gsub(/-+/, "-")
                       .slice(0, 255)

          # Append the id to guarantee uniqueness during backfill
          # even if two articles share the same title.
          final_slug = "#{raw_slug}-#{row['id']}"

          execute(
            "UPDATE articles SET slug = '#{final_slug}' WHERE id = #{row['id']}"
          )
        end
      end
    end
  end
end
