class AddOptionalCommentsSection < ActiveRecord::Migration[5.1]
  def change
    add_column :problems, :include_comments, :boolean
    add_column :activities, :include_comments, :boolean
  end
end
