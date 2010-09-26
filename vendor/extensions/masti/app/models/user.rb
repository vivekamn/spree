class User < ActiveRecord::Base
  attr_accessor :session_key
  attr_accessible :fb_user_id, :session_key
  before_validation :set_login  
  before_save :add_user_role

  has_many :orders
  has_and_belongs_to_many :roles

  belongs_to :ship_address, :foreign_key => "ship_address_id", :class_name => "Address"
  belongs_to :bill_address, :foreign_key => "bill_address_id", :class_name => "Address"

  extend AuthlogicOpenid::ActsAsAuthentic::Config
  include AuthlogicOpenid::ActsAsAuthentic::Methods if User.table_exists?

  acts_as_authentic do |c|
    c.transition_from_restful_authentication = true
    #AuthLogic defaults
    #c.validate_email_field = true
    #c.validates_length_of_email_field_options = {:within => 6..100}
    #c.validates_format_of_email_field_options = {:with => email_regex, :message => I18n.t(‘error_messages.email_invalid’, :default => “should look like an email address.”)}
    #c.validate_password_field = true
    #c.validates_length_of_password_field_options = {:minimum => 4, :if => :require_password?}
    #for more defaults check the AuthLogic documentation
  end
  
  openid_required_fields [:email]
  openid_optional_fields [:nickname]

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :email, :password, :password_confirmation, :login, :openid_identifier

  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.deliver_password_reset_instructions(self)
  end

  # has_role? simply needs to return true or false whether a user has a role or not.  
  def has_role?(role_in_question)
    @_list ||= self.roles.collect(&:name)
    (@_list.include?(role_in_question.to_s) )
  end 
  
  private
  def password_required?
    return false if openid_identifier
    crypted_password.blank? || !password.blank?
  end
   
  # fetch persona from openid.sreg parameters returned by openid server if supported
  # http://openid.net/specs/openid-simple-registration-extension-1_0.html
  def map_openid_registration(registration)
    self.login = registration["nickname"] unless registration["nickname"].blank?
    self.email = registration["email"] unless registration["email"].blank?
  end

  # Since we use attr_accessible or attr_protected,
  # we should overwrite this method defined in authlogic_openid.
  def map_saved_attributes(attrs)
    attrs.each do |key, value|
      send("#{key}=", value)
    end
  end
   
  def set_login
    # for now force login to be same as email, eventually we will make this configurable, etc.
    self.login ||= self.email if self.email
  end 
  
  def add_user_role
    user_role = Role.find_by_name("user")
    self.roles << user_role if user_role and self.roles.empty?
  end
  
  def self.for_facebook(facebook_id, facebook_session=nil)
    returning find_or_create_by_facebook_id(facebook_id) do |facebook_user|
      unless facebook_session.nil?        
        facebook_user.store_session(facebook_session.session_key)
      end
    end
  end
  
  def store_session(session_key)
    if self.session_key!=session_key
      update_attribute(:session_key, session_key)
    end
  end
  
  def facebook_session
    @facebook_session ||= 
    returning Facebooker::Session.create do |session|
      session.secure_with!(session_key,facebook_id,1.hour.from_now)
    end
  end
  
  def publish_stream_allowed    
#   props= {
#     :preload_fql=> {
#          :user_data => {
#            :pattern => "(friends|other)",
#            :query => "SELECT first_name, name,birthday_date,sex from user where uid=#{self.facebook_session.user.uid};" 
#          }}
#   }.to_json
#   Facebooker::Admin.new(Facebooker::Session.create).set_app_properties(props)

    name= self.facebook_session.fql_query("select is_app_user from user where uid == #{self.facebook_session.user.uid}")   
    res = facebook_session.fql_query("select publish_stream from permissions where uid == #{self.facebook_session.user.uid}") 
    puts res.class
    puts res
    if res.join =~ /publish_stream1/
      return true
    else
      return false
    end
  end
  
  
  
end
