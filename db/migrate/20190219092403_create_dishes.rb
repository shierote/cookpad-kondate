class CreateDishes < ActiveRecord::Migration[5.2]
  def change
    create_table :dishes do |t|
      t.string :title
      t.string :url
      t.string :ingredients

      t.timestamps
    end
  end
end
