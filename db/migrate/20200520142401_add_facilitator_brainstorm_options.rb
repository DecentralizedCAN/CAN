class AddFacilitatorBrainstormOptions < ActiveRecord::Migration[5.1]
  def change
    add_column :problems, :facilitator_id, :integer
    add_column :problems, :scoring_method, :integer
  end
end
