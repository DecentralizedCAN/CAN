class CreateRolls < ActiveRecord::Migration[5.1]
  def change
    create_table :rolls do |t|
      t.string :title
      t.text :description
      t.integer :minimum
      t.integer :maximum
      t.belongs_to :activity, foreign_key: true
      t.belongs_to :solution, foreign_key: true

      t.timestamps
    end

    create_join_table :rolls, :users do |t|
      t.index [:roll_id, :user_id]
      t.index [:user_id, :roll_id]
    end
  end
end