class CreatePages < ActiveRecord::Migration[8.0]
  def change
    create_table :pages do |t|
      t.string :title
      t.text :content
      t.string :slug

      t.timestamps
    end
  end
end
