class Refferer < ActiveRecord::Base
  belongs_to :user
  def self.genarate_code(email,user_id=nil)
    record = true
    while record
      random = get_random_code
      record = self.find(:first, :conditions => ["code = ?", random])
    end
    new_record = self.new(:email=>email,:code=>random,:user_id=>user_id)
    new_record.save
    return new_record
  end
  
  def self.get_random_code
    alphanumerics = [('0'..'9'),('A'..'Z'),('a'..'z')].map {|range| range.to_a}.flatten
    return (0...6).map { alphanumerics[Kernel.rand(alphanumerics.size)] }.join
  end
end
