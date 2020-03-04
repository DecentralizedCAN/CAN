class AddGoalsToPosts < ActiveRecord::Migration[5.1]
  def change
    add_reference :activities, :goal, foreign_key: true, index: true
    add_reference :problems, :goal, foreign_key: true, index: true
    add_reference :discussions, :goal, foreign_key: true, index: true
  end
end
