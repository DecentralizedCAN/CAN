class CreateActdissents < ActiveRecord::Migration[5.1]
  def change
    create_table :actdissents do |t|
    	t.string :title
      t.belongs_to :activity, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.timestamps
    end
  end
end