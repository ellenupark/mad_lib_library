class CreateUsersMadLibsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :users_mad_libs do | t |
      t.string :body
      t.integer :user_id 
      t.integer :mad_lib_id
    end
  end
end
