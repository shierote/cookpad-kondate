class AddImageUrlsToDishs < ActiveRecord::Migration[5.2]
  def change
    add_column :dishes, :image_url, :string
  end
end
