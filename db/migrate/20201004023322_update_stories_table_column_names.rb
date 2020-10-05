class UpdateStoriesTableColumnNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :stories, :body, :input
    add_column :stories, :sentence, :string
  end
end
