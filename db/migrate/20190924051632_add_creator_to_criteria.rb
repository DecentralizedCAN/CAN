class AddCreatorToCriteria < ActiveRecord::Migration[5.1]
  def change
    add_column :criteria, :creator, :string
  end
end
