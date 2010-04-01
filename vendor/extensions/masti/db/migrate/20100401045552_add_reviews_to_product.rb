class AddReviewsToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :reviews, :text
  end

  def self.down
    remove_column :products, :reviews
  end
end