require 'open-uri'

  Dish.all.each do |dish|
    next if dish.image_url?
    doc = Nokogiri::HTML(open(dish.url))
    dish.image_url = doc.xpath('//meta[@property="og:image"]/@content').inner_text
    p dish.image_url
    dish.save
  end
