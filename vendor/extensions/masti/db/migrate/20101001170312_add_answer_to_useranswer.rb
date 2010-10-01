class AddAnswerToUseranswer < ActiveRecord::Migration
  def self.up
    add_column :active_poll_user_answers, :direct_answer,:string
  end

  def self.down
    remove_column :active_poll_user_answers, :direct_answer
  end
end