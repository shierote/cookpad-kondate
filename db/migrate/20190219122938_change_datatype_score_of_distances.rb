class ChangeDatatypeScoreOfDistances < ActiveRecord::Migration[5.2]
  def change
    change_column :distances, :score, :float
  end
end
