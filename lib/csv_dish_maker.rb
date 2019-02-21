require 'csv'

MATRIX_CSV_NAME = 'cost_table.csv'
DISH_CSV_NAME = 'url_and_ingredients_table.csv'

CSV.foreach("public/#{DISH_CSV_NAME}") do |line|
  Dish.transaction do
    dish = Dish.new(title: line[0], url: line[1], ingredients: line[2])
    p dish
    dish.save
    p dish.id
  end
end
