# Provide tasks to load data we have manually gathered
require 'active_record'
require 'active_record/fixtures'
require 'csv'
#require 'riddle'
#require 'htmlentities'
require 'logger'


#DATA_DIRECTORY = File.join(RAILS_ROOT, "lib", "tasks", "sample_data")
namespace :db do
  namespace :masthi_common do 
    desc "set sample user flag"
    task :set_sample_user => :environment do |t|
      set_sample_user
    end
  end
end

  def set_sample_user
    logger = Logger.new STDOUT
    users= User.find(:all,:conditions => ['phone_no IS NULL '])
    users.each do |user|
      user.is_sample = true
      user.save!
      logger.info "user saved as sample user---->#{user.email}"
    end
  end