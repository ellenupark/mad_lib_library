class RenameUsersMadLibsTable < ActiveRecord::Migration[5.2]
  def change
    rename_table :users_mad_libs, :user_madlibs
  end
end
