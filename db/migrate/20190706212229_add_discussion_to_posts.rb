class AddDiscussionToPosts < ActiveRecord::Migration[5.1]
  def change
    add_reference :posts, :discussion, foreign_key: true
  end
end
