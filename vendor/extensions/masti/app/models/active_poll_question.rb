class ActivePollQuestion < ActiveRecord::Base
  has_many :active_poll_answers, :dependent => :destroy
  belongs_to :product
  #after_save :create_name
  after_update :save_answers
  #attr_accessor :active_poll_answers
  #accepts_nested_attributes_for :active_poll_answers
  def new_active_poll_answers_attributes=(active_poll_answers_attributes)
    active_poll_answers_attributes.each do |attributes|       
      active_poll_answers.build(attributes) unless attributes[:description].empty?
    end
  end
  
  def self.deactivate_previous_poll
    previous_poll = ActivePollQuestion.find(:first, :conditions=>['is_active = ?', true])
    previous_poll.update_attribute(:is_active, false) unless previous_poll.nil?
  end
  
  def self.find_previous_poll_id
    previous_poll = ActivePollQuestion.find(:first, :order=>['created_at DESC'])
    unless previous_poll.nil?
      id=previous_poll.id
    else
      id=0
    end
    id
  end
  
  def existing_active_poll_answers_attributes=(active_poll_answers_attributes)
  active_poll_answers.reject(&:new_record?).each do |answer|
    attributes = active_poll_answers_attributes[answer.id.to_s]
    if attributes
      answer.attributes = attributes
    else
      active_poll_answers.delete(answer)
    end
  end
end

def save_answers
  active_poll_answers.each do |answer|
    answer.save(false)
  end
end

def create_name
  name = "active_poll_#{id}"
  save!
end


end
