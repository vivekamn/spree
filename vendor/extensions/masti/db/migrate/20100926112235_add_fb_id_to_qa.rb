class AddFbIdToQa < ActiveRecord::Migration
  def self.up
    add_column(:active_poll_user_answers, :fb_user_id, :double)
  end

  def self.down
    remove_column(:active_poll_user_answers, :fb_user_id)
  end
end