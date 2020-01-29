class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :content_ciphertext
      t.references :discussion, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
