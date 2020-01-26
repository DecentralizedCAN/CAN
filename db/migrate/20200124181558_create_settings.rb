class CreateSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.string :title
      t.boolean :state

      t.timestamps
    end
  end
end
