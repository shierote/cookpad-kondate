require 'csv'

MATRIX_CSV_NAME = 'cost_table.csv'
DISH_CSV_NAME = 'url_and_ingredients_table.csv'

title_list = []
CSV.foreach("public/#{MATRIX_CSV_NAME}") do |line|
  if line[0].nil?
    title_list += line
    next
  end
  title_list.compact!
  another_dish = Dish.find_by(title: line[0]) 
  Distance.transaction do
    line.drop(1).each_with_index do |score, i|
      next if score.to_f < 0.31
      dish = Dish.find_by(title: title_list[i])
      distance = Distance.new(dish_id: dish.id, another_dish_id: another_dish.id, score: score.to_f)
      p distance
      distance.save
    end
  end
end
