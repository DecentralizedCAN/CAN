class AddDraftToSolutions < ActiveRecord::Migration[5.1]
  def change
    add_column :solutions, :draft, :boolean
  end
end
