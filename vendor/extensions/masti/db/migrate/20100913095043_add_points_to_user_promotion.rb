class AddPointsToUserPromotion < ActiveRecord::Migration
  def self.up
    add_column :user_promotions,:points,:integer,:default =>0
    add_column :user_promotions,:email,:string
  end

  def self.down
    remove_column :user_promotions,:points
    remove_column :user_promotions,:email
  end
end