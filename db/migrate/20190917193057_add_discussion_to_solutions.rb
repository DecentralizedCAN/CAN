class AddDiscussionToSolutions < ActiveRecord::Migration[5.1]
  def change
    add_reference :solutions, :discussion, foreign_key: true
  end
end
