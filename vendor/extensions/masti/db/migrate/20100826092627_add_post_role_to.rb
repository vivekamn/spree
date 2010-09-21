class AddPostRoleTo < ActiveRecord::Migration
  def self.up
    role = Role.new(:name=>"post")
    role.save
  end

  def self.down
    
  end
end