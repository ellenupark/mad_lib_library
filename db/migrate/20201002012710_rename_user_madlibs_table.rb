class RenameUserMadlibsTable < ActiveRecord::Migration[5.2]
  def change
    rename_table :user_madlibs, :stories
  end
end
