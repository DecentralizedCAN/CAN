class CreateDiscussions < ActiveRecord::Migration[5.1]
  def change
    create_table :discussions do |t|
      t.string :title
      t.text :content
      t.references :post, foreign_key: true
      t.references :problem, foreign_key: true
      t.references :activity, foreign_key: true

      t.timestamps
    end
  end
end
