class AddCommentsToDiscussions < ActiveRecord::Migration[5.1]
  def change
    add_reference :discussions, :comment, foreign_key: true
  end
end
