class CreateDistances < ActiveRecord::Migration[5.2]
  def change
    create_table :distances do |t|
      t.integer :dish_id
      t.integer :another_dish_id
      t.integer :score

      t.timestamps
    end
  end
end
