class CreateProblems < ActiveRecord::Migration[5.1]
  def change
    create_table :problems do |t|
      t.text :title_ciphertext
      t.text :description_ciphertext
      t.text :suggestion_min_ciphertext
      t.integer :updated

      t.timestamps
    end

    create_join_table :problems, :users do |t|
      t.index [:problem_id, :user_id]
      t.index [:user_id, :problem_id]
    end
  end
end
