class PopulateIndianStates < ActiveRecord::Migration
  def self.up
    create = <<END_OF_STRING
      INSERT INTO `states` (`name`,`abbr`,`country_id`)VALUES ('Andhra Pradhesh','AP','92'),
           ('Arunachal Pradesh','ARP','92'),
       ('Assam','ASS','92'),
       ('Bihar','BIH','92'),
       ('Chhattisgarh','CTG','92'),
       ('Goa','GOA','92'),
       ('Gujarat','GUJ','92'),
      ('Haryana','HAR','92'),
       ('Himachal Pradesh','HIM','92'),
       ('Jammu and Kashmir','JK','92'),
       ('Jharkhand','JAR','92'),
       ('Karnataka','KAR','92'),
       ('Kerala','KER','92'),
       ('Madhya Pradesh','MP','92'),
      ('Maharashtra','MAH','92'),
       ('Manipur','MAN','92'),
       ('Meghalaya','MEG','92'),
       ('Mizoram','MIZ','92'),
       ('Nagaland','NAG','92'),
       ('Orissa','ORI','92'),
       ('Punjab','PUN','92'),
      ('Rajasthan','RAJ','92'),
       ('Sikkim','SIK','92'),
       ('Tamil Nadu','TN','92'),
       ('Tripura','TRI','92'),
       ('Uttar Pradesh','UP','92'),
       ('Uttarakhand','UTT','92'),
       ('West Bengal','WB','92'),
      ('Andaman and Nicobar','AND','92'),
       ('Chandigarh','CHA','92'),
       ('Dadra and Nagar Haveli','DAD','92'),
       ('Daman and Diu','DAM','92'),
       ('Delhi','DEL','92'),
       ('Lakshadweep','LAK','92'),
       ('Puducherry','PUD','92');
END_OF_STRING
      execute create   
  end

  def self.down
  end
end