class CreateDiscussions < ActiveRecord::Migration[5.1]
  def change
    create_table :discussions do |t|
      t.text :title_ciphertext
      t.text :content_ciphertext
      t.references :post, foreign_key: true
      t.references :problem, foreign_key: true
      t.references :activity, foreign_key: true

      t.timestamps
    end
  end
end
