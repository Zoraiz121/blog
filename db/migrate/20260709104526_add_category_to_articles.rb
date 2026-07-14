class AddCategoryToArticles < ActiveRecord::Migration[7.2]
  def change
    add_column :articles, :category, :string
  end
end
