class SetSampleUser < ActiveRecord::Migration
  def self.up
    query = "UPDATE users SET is_sample=1 WHERE phone_no IS NULL"
    results = connection.execute(query)
  end

  def self.down
  end
end