class AddLikePaidPromotion < ActiveRecord::Migration
  def self.up
    add_column :user_promotions,:fb_like_paid,:boolean,:default =>false
  end

  def self.down
    remove_column :user_promotions,:fb_like_paid
  end
end