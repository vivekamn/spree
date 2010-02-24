class CreateDealHistories < ActiveRecord::Migration

  def self.up
    create_table "deal_histories", :force => true do |t|
      t.integer   "product_id"
      t.datetime   "deal_started_at"
      t.datetime   "deal_completed_at"
      t.boolean  "is_active", :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :deal_histories
  end    

end
