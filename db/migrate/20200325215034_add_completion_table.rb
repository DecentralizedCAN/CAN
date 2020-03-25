class AddCompletionTable < ActiveRecord::Migration[5.1]
  def change
    create_table :completions do |t|
      t.references :roll, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
