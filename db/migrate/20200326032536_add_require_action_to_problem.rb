class AddRequireActionToProblem < ActiveRecord::Migration[5.1]
  def change
    add_column :problems, :require_action, :boolean
  end
end
