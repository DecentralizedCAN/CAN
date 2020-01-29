class CreateSolutions < ActiveRecord::Migration[5.1]
  def change
    create_table :solutions do |t|
      t.text :title_ciphertext
      t.text :description_ciphertext
      t.integer :score
      t.belongs_to :problem, foreign_key: true

      t.timestamps
    end

    create_join_table :solutions, :users do |t|
      t.index [:solution_id, :user_id]
      t.index [:user_id, :solution_id]
    end
  end
end
