class AddUserIdToArticles < ActiveRecord::Migration[7.2]
  def change
    # Add user_id column. Allow null initially so existing rows
    # do not immediately violate the constraint before we set defaults.
    add_reference :articles, :user, null: true, foreign_key: true, index: true

    # If there are existing articles in development with no owner,
    # assign them to the first user to prevent orphaned records.
    # This only runs if any articles exist without a user_id.
    reversible do |dir|
      dir.up do
        first_user_id = execute("SELECT id FROM users ORDER BY id LIMIT 1").first&.[]("id")

        if first_user_id
          execute("UPDATE articles SET user_id = #{first_user_id} WHERE user_id IS NULL")
        end
      end
    end

    # Now that all rows have a user_id, tighten the constraint to NOT NULL.
    change_column_null :articles, :user_id, false
  end
end
