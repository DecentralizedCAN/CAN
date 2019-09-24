class AddCreatorToSolutions < ActiveRecord::Migration[5.1]
  def change
    add_column :solutions, :creator, :string
  end
end
