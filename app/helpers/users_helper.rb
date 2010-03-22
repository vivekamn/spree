module UsersHelper       
  def password_style(user)
    show_openid ? "display:none" : ""
  end         
  def openid_style(user) 
    show_openid ? "": "display:none"
  end
  
   def admin?
    if current_user==User.first(:include => :roles, :conditions => ["roles.name = 'admin'"])
      return true
    else
      return false
    end
    
  end
 
  private 
  def show_openid
    Spree::Config[:allow_openid] and @user.openid_identifier
  end
end