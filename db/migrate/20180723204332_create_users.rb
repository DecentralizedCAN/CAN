class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name_ciphertext
      t.string :name_bidx
      t.index :name_bidx, unique: true
      t.string :email_ciphertext
      t.string :email_bidx
      t.index :email_bidx, unique: true
      t.boolean :email_notifications, :default => true

      t.timestamps
    end
  end
end
