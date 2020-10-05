class CreateMadLibsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :mad_libs do | t |
      t.string :title
      t.string :sentence
      t.string :blank
    end
  end
end
