class PopulateCities < ActiveRecord::Migration
  def self.up    
      create = <<END_OF_STRING
      INSERT INTO `cities` (`name`,`state_id`) VALUES ('Chennai','1061493609'),
      ('Bangalore','1061493597'),
      ('Mumbai','1061493600'),
      ('New Delhi','1061493618');
END_OF_STRING
      execute create   
           
  end

  def self.down
  end
end