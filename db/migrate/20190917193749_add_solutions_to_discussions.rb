class AddSolutionsToDiscussions < ActiveRecord::Migration[5.1]
  def change
    add_reference :discussions, :solution, foreign_key: true
  end
end
