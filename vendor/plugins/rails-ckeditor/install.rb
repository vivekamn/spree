# Install hook code here

directory = File.join(RAILS_ROOT, '/vendor/plugins/rails-ckeditor/')
require "#{directory}lib/ckeditor_file_utils"
require "#{directory}lib/ckeditor_version"
require "#{directory}lib/ckeditor"

puts "** Installing Easy CKEditor Plugin version #{CkeditorVersion.current}...."

CkeditorFileUtils.destroy_and_install

puts "** Successfully installed Easy CKEditor Plugin version #{CkeditorVersion.current}"
