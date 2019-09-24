class AddCreatorToOthers < ActiveRecord::Migration[5.1]
  def change
    add_column :problems, :creator, :string
    add_column :activities, :creator, :string
    add_column :discussions, :creator, :string
  end
end
