class SampleUserFlag < ActiveRecord::Migration
  def self.up
    add_column :users, :is_sample, :boolean ,:default => false
  end

  def self.down
    remove_column :users, :is_sample
  end
end