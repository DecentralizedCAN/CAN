class AddContentCiphertextToDiscussions < ActiveRecord::Migration[5.1]
  def change
    add_column :discussions, :content_ciphertext, :text
  end
end
