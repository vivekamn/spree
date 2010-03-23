
namespace :db do        
  namespace :image_dimensions do                       
    desc "For new dimensions" 
    task :change_dimensions => :environment do
      change_dimensions
    end
  end
end

def change_dimensions
  logger = Logger.new STDOUT  
  logger.info "changing image sizes------------"
  begin
  Image.all.each{|i| i.attachment.reprocess!}
  logger.info "completed successfully"
rescue Exception => e
  logger.debug "not able to complete-----------"+e.message  
end
end
