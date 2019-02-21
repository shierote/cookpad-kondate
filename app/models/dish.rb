class Dish < ApplicationRecord
  has_many :distances
  has_many :kondates, dependent: :destroy
  validates :title, presence: true
  validates :url, presence: true
  validates :ingredients, presence: true

  def make_a_week_kondate
    day_1_kondate = self.make_1_day_kondate
    day_2_kondate = self.make_2_day_kondate
    self.make_one_days_kondate(3, day_1_kondate)
    self.make_one_days_kondate(4, day_2_kondate)
    self.make_one_days_kondate(5, day_1_kondate)
    self.make_one_days_kondate(6, day_2_kondate)
    self.make_one_days_kondate(7, day_1_kondate)
  end

  def make_1_day_kondate
    # 1日目の献立作成
    kondate = Kondate.new(day: 1, dish_id: self.id)
    case self.dish_type
    when 0
      kondate.b_v_id = self.id
    else
      kondate.l_fm_id = self.id
    end
    kondate.b_v_id = self.get_random_dish(0).id if kondate.b_v_id.nil?
    kondate.save
    kondate.l_v_id = self.get_random_dish(0).id
    kondate.save
    kondate.l_fm_id = self.get_random_dish(Random.rand(0..1)).id if kondate.l_fm_id.nil?
    kondate.save
    kondate.d_v_id = self.get_random_dish(0).id
    kondate.save
    kondate.d_fm_id = self.get_random_dish(Random.rand(0..1)).id
    kondate.save
    return kondate
  end

  def make_2_day_kondate
    kondate = Kondate.new(day: 2, dish_id: self.id)
    kondate.b_v_id = self.get_random_dish(0).id
    kondate.save
    kondate.l_v_id = self.get_random_dish(0).id
    kondate.save
    kondate.l_fm_id = self.get_random_dish(Random.rand(0..1)).id
    kondate.save
    kondate.d_v_id = self.get_random_dish(0).id
    kondate.save
    kondate.d_fm_id = self.get_random_dish(Random.rand(0..1)).id
    kondate.save
    return kondate
  end

  def make_one_days_kondate(i, ref_day_kondate)
    Kondate.transaction do
      kondate = Kondate.new(day: i, dish_id: self.id)
      kondate.save
      kondate.b_v_id = self.get_similar_dishes(ref_day_kondate.b_v_id)
      kondate.save
      kondate.l_v_id = self.get_similar_dishes(ref_day_kondate.l_v_id)
      kondate.save
      kondate.l_fm_id = self.get_similar_dishes(ref_day_kondate.l_fm_id)
      kondate.save
      kondate.d_v_id = self.get_similar_dishes(ref_day_kondate.d_v_id)
      kondate.save
      kondate.d_fm_id = self.get_similar_dishes(ref_day_kondate.d_fm_id)
      kondate.save
    end
  end

  def get_similar_dishes(id)
    dish = Dish.find(id)
    distances = Distance.where(dish_id: id).order(score: :desc)
    if distances.present?
      distances = distances.select {|d| self.kondate_not_have?(d.another_dish_id)}
      distances = distances.select {|d| Dish.find(d.another_dish_id).dish_type == dish.dish_type }
    end
    if distances.present?
      return distances.first.another_dish_id
    else
      get_random_dish(dish.dish_type).id
    end
  end

  def get_random_dish(dish_type=nil)
    if dish_type.nil?
      other_dishes = Dish.where.not(id: self.id).order("RANDOM()")
    else
      other_dishes = Dish.where(dish_type: dish_type).where.not(id: self.id).order("RANDOM()")
    end
    other_dishes.each do |dish|
      return dish if self.kondate_not_have?(dish.id)
    end
  end
  
  def kondate_not_have?(target_id)
    kondate = Kondate.where(dish_id: self.id)
    kondate.each do |k|
      list = [k.b_v_id, k.l_v_id, k.l_fm_id, k.d_v_id, k.d_fm_id]
      if list.include?(target_id)
        return false
      end
    end
    return true
  end
end
