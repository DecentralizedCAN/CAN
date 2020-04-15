class AddGoalsAndLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :goals do |t|
      t.string :title_ciphertext
      t.string :title_bidx
      t.index :title_bidx, unique: true
			t.references :activities, index: true, foreign_key: true
			t.references :problems, index: true, foreign_key: true
			t.references :discussions, index: true, foreign_key: true
		end

    create_table :links do |t|
			t.references :parent, index: true, foreign_key: { to_table: :goals }
			t.references :child, index: true, foreign_key: { to_table: :goals }
		end

		create_join_table :goals, :users do |t|
		  t.index [:goal_id, :user_id]
		  t.index [:user_id, :goal_id]
		end

		create_join_table :links, :users do |t|
		  t.index [:link_id, :user_id]
		  t.index [:user_id, :link_id]
		end

  end
end