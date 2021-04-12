class AddCofacilitatorsToBrainstorm < ActiveRecord::Migration[5.1]
  def change
    create_table :cofacilitators do |t|
      t.references :problem, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
