class AddSideDealEndDate < ActiveRecord::Migration
  def self.up
    add_column :deal_histories,:side_deal_completed_at, :datetime
    add_column :deal_histories, :side_deal_started_at, :datetime
  end

  def self.down
    remove_column :deal_histories, :side_deal_completed_at
    remove_column :deal_histories, :side_deal_started_at
  end
end