class CreateCriteria < ActiveRecord::Migration[5.1]
  def change
    create_table :criteria do |t|
      t.text :title_ciphertext
      t.text :alternatives_ciphertext
      t.belongs_to :problem, foreign_key: true
      t.timestamps
    end

    create_join_table :criteria, :users do |t|
      t.index [:criterium_id, :user_id]
      t.index [:user_id, :criterium_id]
    end
  end
end