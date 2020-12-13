class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.text :description

      t.timestamps
    end

    create_join_table :groups, :users do |t|
      t.index [:group_id, :user_id]
      t.index [:user_id, :group_id]
    end

    add_reference :posts, :group, foreign_key: true
  end
end