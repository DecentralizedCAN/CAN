class Crialt < ActiveRecord::Migration[5.1]
  def change
    create_table :crialts do |t|
      t.text :alternative
      t.belongs_to :criterium, foreign_key: true
      t.integer :transferred_user_count
      t.timestamps
    end
  end
end
