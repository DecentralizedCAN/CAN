class Postlinks < ActiveRecord::Migration[5.1]
  def change
    create_table :alinks do |t|
      t.references :goal, index: true, foreign_key: { to_table: :goals }
      t.references :action, index: true, foreign_key: { to_table: :activities }
    end

    create_table :blinks do |t|
      t.references :goal, index: true, foreign_key: { to_table: :goals }
      t.references :brainstorm, index: true, foreign_key: { to_table: :problems }
    end

    create_table :dlinks do |t|
      t.references :goal, index: true, foreign_key: { to_table: :goals }
      t.references :discussion, index: true, foreign_key: { to_table: :discussions }
    end

    create_join_table :alinks, :users do |t|
      t.index [:alink_id, :user_id]
      t.index [:user_id, :alink_id]
    end

    create_join_table :blinks, :users do |t|
      t.index [:blink_id, :user_id]
      t.index [:user_id, :blink_id]
    end

    create_join_table :dlinks, :users do |t|
      t.index [:dlink_id, :user_id]
      t.index [:user_id, :dlink_id]
    end
  end
end