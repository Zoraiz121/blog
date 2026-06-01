class AddUserIdToComments < ActiveRecord::Migration[7.2]
  def change
    # Same pattern as articles — allow null initially, backfill, then tighten.
    add_reference :comments, :user, null: true, foreign_key: true, index: true

    reversible do |dir|
      dir.up do
        first_user_id = execute("SELECT id FROM users ORDER BY id LIMIT 1").first&.[]("id")

        if first_user_id
          execute("UPDATE comments SET user_id = #{first_user_id} WHERE user_id IS NULL")
        end
      end
    end

    change_column_null :comments, :user_id, false
  end
end
