class FixColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :user_madlibs, :mad_lib_id, :madlib_id
  end
end
