class AddCommentsToUpvotes < ActiveRecord::Migration[5.1]
  def change
    add_reference :upvotes, :comment, foreign_key: true
  end
end
