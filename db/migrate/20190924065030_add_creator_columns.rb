class AddCreatorColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :solutions, :creator_ciphertext, :text
    add_column :criteria, :creator_ciphertext, :text
    add_column :problems, :creator_ciphertext, :text
    add_column :activities, :creator_ciphertext, :text
    add_column :discussions, :creator_ciphertext, :text
  end
end
