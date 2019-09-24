class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.boolean :visible, :default => true
      t.references :problem, foreign_key: true
      t.references :activity, foreign_key: true

      t.timestamps
    end
  end
end
