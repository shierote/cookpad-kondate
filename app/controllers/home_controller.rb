require 'open-uri'

class HomeController < ApplicationController
  def top
    @dishes = Dish.all.sample(40)
  end

  def index
    @dishes = Dish.where("ingredients LIKE ?", "%#{params["q"]}%").or(Dish.where("title LIKE ?", "%#{params["q"]}%"))
  end

  def show
    @dish = Dish.find(params["id"])
    @kondates = Kondate.find_by(dish_id: @dish.id)
    if @kondates.nil?
      @dish.make_a_week_kondate
    end
    @kondates = Kondate.where(dish_id: @dish.id)
    @ingredients = Hash.new(0)
    ary = []
    @kondates.each do |kondate|
      ary.push(Dish.find(kondate.b_v_id).ingredients.gsub('', ' ').split(','))
      ary.push(Dish.find(kondate.l_v_id).ingredients.gsub('', ' ').split(','))
      ary.push(Dish.find(kondate.l_fm_id).ingredients.gsub('', ' ').split(','))
      ary.push(Dish.find(kondate.d_v_id).ingredients.gsub('', ' ').split(','))
      ary.push(Dish.find(kondate.d_fm_id).ingredients.gsub('', ' ').split(','))
    end
    ary.flatten!
    ary.each do |elem|
      @ingredients[elem] += 1
    end
  end

  def create
    redirect_to home_index_path(q: params["meal"]["name"])
  end
end
