class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :meals_count

      t.timestamps
    end
  end
end
