class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.string :title
      t.text :description
      t.text :activation
      t.text :participants
      t.integer :deadline
      t.integer :expiration
      t.references :solution

      t.timestamps
    end

    create_join_table :activities, :users do |t|
      t.index [:activity_id, :user_id]
      t.index [:user_id, :activity_id]
    end
  end
end