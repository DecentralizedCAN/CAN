class CreatePolls < ActiveRecord::Migration[5.1]
  def change
    create_table :polls do |t|
      t.integer :answer
      t.belongs_to :criterium, foreign_key: true
      t.belongs_to :solution, foreign_key: true
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
