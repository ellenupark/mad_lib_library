class RenameMadLibsTable < ActiveRecord::Migration[5.2]
  def change
    rename_table :mad_libs, :madlibs
  end
end
