class ActivePollAnswer < ActiveRecord::Base
  belongs_to :active_poll_question
  has_many :active_poll_user_answers, :dependent => :destroy
  #accepts_nested_attributes_for :active_poll_question 
end
