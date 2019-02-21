require 'csv'

MATRIX_CSV_NAME = 'cost_table.csv'
DISH_CSV_NAME = 'url_and_ingredients_table.csv'

CSV.foreach("public/#{DISH_CSV_NAME}") do |line|
  Dish.transaction do
    next if line[0].nil?
    dish = Dish.find_by(title: line[0])
    dish.ingredients = line[2].delete("[]'\\\\")
    dish.dish_type = line[3].to_i
    p dish
    dish.save
  end
end
