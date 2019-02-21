class CreateKondates < ActiveRecord::Migration[5.2]
  def change
    create_table :kondates do |t|
      t.integer :day
      t.integer :dish_id
      t.integer :b_v_id
      t.integer :l_v_id
      t.integer :l_fm_id
      t.integer :d_v_id
      t.integer :d_fm_id

      t.timestamps
    end
  end
end
