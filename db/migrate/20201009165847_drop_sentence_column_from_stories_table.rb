class DropSentenceColumnFromStoriesTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :stories, :sentence
  end
end
