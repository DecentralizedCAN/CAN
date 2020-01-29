class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.text :title_ciphertext
      t.text :description_ciphertext
      t.text :activation_ciphertext
      t.string :deadline_ciphertext
      t.string :deadline_bidx
      t.index :deadline_bidx
      t.string :expiration_ciphertext
      t.string :expiration_bidx
      t.index :expiration_bidx
      t.references :solution

      t.timestamps
    end

    create_join_table :activities, :users do |t|
      t.index [:activity_id, :user_id]
      t.index [:user_id, :activity_id]
    end
  end
end