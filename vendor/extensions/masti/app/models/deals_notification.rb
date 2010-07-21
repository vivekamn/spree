class DealsNotification < ActiveRecord::Base
  validates_presence_of :email 
  validates_format_of(:email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i)
  after_create :call_count_mailer
   
   def call_count_mailer
      user_count = DealsNotification.count(:all)
      UserMailer.deliver_count_to_admin(user_count,self.email,"Deal Notification")
    end
  
  def self.find_by_email(email)
    DealsNotification.find(:first,:conditions => "email = '#{email}'")
  end
  
  def self.find_by_is_send_email(value)
    DealsNotification.find(:all,:conditions => "is_send_email = '#{value}'")
  end
end
