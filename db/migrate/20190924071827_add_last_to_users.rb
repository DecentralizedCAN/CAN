class AddLastToUsers < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :last_posted, :timestamp
  end
end
