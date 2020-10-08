class AddCreatedAtColumnToStoriesTable < ActiveRecord::Migration[5.2]
  def change
    add_timestamps :stories, null: true
    add_timestamps :users, null: true
  end
end

