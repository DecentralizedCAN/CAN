class CreateCridissents < ActiveRecord::Migration[5.1]
  def change
    create_table :cridissents do |t|
		t.text :title_ciphertext
      	t.belongs_to :criterium, foreign_key: true
      	t.belongs_to :user, foreign_key: true
  		t.timestamps
    end
  end
end
