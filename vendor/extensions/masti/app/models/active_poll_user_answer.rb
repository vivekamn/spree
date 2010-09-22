class ActivePollUserAnswer < ActiveRecord::Base
  belongs_to :active_poll_answer
  belongs_to :user
end
