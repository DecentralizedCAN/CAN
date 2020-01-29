class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.text :details_ciphertext
      t.references :user, foreign_key: true
      t.references :criterium, foreign_key: true
      t.references :activity, foreign_key: true
      t.references :problem, foreign_key: true
      t.references :discussion, foreign_key: true

      t.timestamps
    end
  end
end
