class Layout < ActiveRecord::Base
  has_many :taxons
  has_attached_file :screenshot, 
                    :styles => { :mini => '48x48>', :small => '100x100>', :large => '600x600>' }, 
                    :default_style => :small,
                    :url => "/assets/layouts/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/layouts/:id/:style/:basename.:extension"
end